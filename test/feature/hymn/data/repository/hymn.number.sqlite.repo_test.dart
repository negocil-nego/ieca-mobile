import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

/// Creates the test database file at the same path openAppDatabase() expects.
Future<String> _createTestDb() async {
  final dbDir = await sqflite.getDatabasesPath();
  final dbPath = p.join(dbDir, 'app.db');

  // Delete any existing database and close connections
  try {
    await databaseFactoryFfi.deleteDatabase(dbPath);
  } catch (_) {}
  final file = File(dbPath);
  if (await file.exists()) await file.delete();

  final db = await databaseFactoryFfi.openDatabase(dbPath);

  await db.execute('''
    CREATE TABLE tb_sections (
      id INTEGER PRIMARY KEY, code TEXT NOT NULL, name TEXT NOT NULL,
      is_active INTEGER NOT NULL DEFAULT 0
    )
  ''');
  await db.execute('''
    CREATE TABLE tb_hymns_group (
      id INTEGER PRIMARY KEY, name TEXT NOT NULL,
      beginning INTEGER NOT NULL, finished INTEGER NOT NULL,
      section_id INTEGER NOT NULL
    )
  ''');
  await db.execute('''
    CREATE TABLE tb_hymns_number (
      id INTEGER PRIMARY KEY, num INTEGER NOT NULL,
      code TEXT NOT NULL, label TEXT NOT NULL,
      type TEXT NOT NULL DEFAULT 'NORMAL',
      hymns_group_id INTEGER NOT NULL,
      last_accessed_at INTEGER,
      is_favorite INTEGER NOT NULL DEFAULT 0,
      access_count INTEGER NOT NULL DEFAULT 0
    )
  ''');
  await db.execute('''
    CREATE TABLE tb_hymns_content (
      id INTEGER PRIMARY KEY, position INTEGER NOT NULL,
      content TEXT NOT NULL,
      type_stanza TEXT NOT NULL DEFAULT 'VERSE',
      lang TEXT NOT NULL,
      hymns_number_id INTEGER NOT NULL
    )
  ''');

  await db.insert('tb_sections', {'id': 1, 'code': 'PT', 'name': 'Português', 'is_active': 1});
  await db.insert('tb_sections', {'id': 2, 'code': 'EN', 'name': 'English', 'is_active': 1});

  await db.insert('tb_hymns_group', {'id': 1, 'name': 'Louvor', 'beginning': 1, 'finished': 50, 'section_id': 1});
  await db.insert('tb_hymns_group', {'id': 2, 'name': 'Adoração', 'beginning': 51, 'finished': 100, 'section_id': 1});
  await db.insert('tb_hymns_group', {'id': 3, 'name': 'Praise', 'beginning': 1, 'finished': 30, 'section_id': 2});

  await db.insert('tb_hymns_number', {'id': 1, 'num': 1, 'code': '001', 'label': 'Hino 1', 'type': 'NORMAL', 'hymns_group_id': 1, 'last_accessed_at': null, 'is_favorite': 0, 'access_count': 0});
  await db.insert('tb_hymns_number', {'id': 2, 'num': 2, 'code': '002', 'label': 'Hino 2', 'type': 'NORMAL', 'hymns_group_id': 1, 'last_accessed_at': 1000, 'is_favorite': 1, 'access_count': 5});
  await db.insert('tb_hymns_number', {'id': 3, 'num': 3, 'code': '003', 'label': 'Hino 3', 'type': 'ADICIONAL', 'hymns_group_id': 1, 'last_accessed_at': null, 'is_favorite': 0, 'access_count': 0});
  await db.insert('tb_hymns_number', {'id': 4, 'num': 51, 'code': '051', 'label': 'Hino 51', 'type': 'NORMAL', 'hymns_group_id': 2, 'last_accessed_at': null, 'is_favorite': 0, 'access_count': 0});
  await db.insert('tb_hymns_number', {'id': 5, 'num': 52, 'code': '052', 'label': 'Hino 52', 'type': 'NORMAL', 'hymns_group_id': 2, 'last_accessed_at': null, 'is_favorite': 0, 'access_count': 0});

  await db.close();
  return dbPath;
}

void main() {
  sqfliteFfiInit();
  sqflite.databaseFactory = databaseFactoryFfi;

  group('HymnNumberSqliteRepo', () {
    late String dbPath;
    late HymnNumberSqliteRepo repo;
    late Section sectionPT;
    late Section sectionEN;
    late HymnsGroup group1;

    setUp(() async {
      dbPath = await _createTestDb();
      repo = HymnNumberSqliteRepo();
      sectionPT = Section(id: 1, code: 'PT', name: 'Português', isActive: 1);
      sectionEN = Section(id: 2, code: 'EN', name: 'English', isActive: 1);
      group1 = HymnsGroup(id: 1, name: 'Louvor', beginning: 1, finished: 50, section: sectionPT);
    });

    tearDown(() async {
      try {
        await databaseFactoryFfi.deleteDatabase(dbPath);
      } catch (_) {}
    });

    test('count returns number of NORMAL hymns', () async {
      final result = await repo.count();

      expect(result, 4);
    });

    test('countBySection returns count for given section', () async {
      final result = await repo.countBySection(sectionPT);

      expect(result, 4);
    });

    test('countBySection returns 0 for section with no NORMAL hymns', () async {
      final result = await repo.countBySection(sectionEN);

      expect(result, 0);
    });

    test('findByHymnsGroup returns NORMAL hymns ordered by num', () async {
      final result = await repo.findByHymnsGroup(group1);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      final list = (result as Ok).value;
      expect(list.length, 2);
      expect(list[0].id, 1);
      expect(list[0].num, 1);
      expect(list[1].id, 2);
      expect(list[1].num, 2);
    });

    test('findByHymnsGroup excludes ADICIONAL type', () async {
      final result = await repo.findByHymnsGroup(group1);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      final list = (result as Ok).value;
      expect(list.where((n) => n.id == 3), isEmpty);
    });

    test('findByHymnsGroup returns empty for group with no hymns', () async {
      final emptyGroup = HymnsGroup(id: 99, name: 'Empty', beginning: 0, finished: 0, section: sectionPT);
      final result = await repo.findByHymnsGroup(emptyGroup);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      expect((result as Ok).value, isEmpty);
    });

    test('findFavouritesByGroup returns only favorites', () async {
      final result = await repo.findFavouritesByGroup(group1);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      final list = (result as Ok).value;
      expect(list.length, 1);
      expect(list[0].id, 2);
      expect(list[0].isFavorite, isTrue);
    });

    test('findFavouritesByGroup returns empty when no favorites', () async {
      final group2 = HymnsGroup(id: 2, name: 'Adoração', beginning: 51, finished: 100, section: sectionPT);
      final result = await repo.findFavouritesByGroup(group2);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      expect((result as Ok).value, isEmpty);
    });

    test('findFavouritesBySection returns favorites in section', () async {
      final result = await repo.findFavouritesBySection(sectionPT);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      final list = (result as Ok).value;
      expect(list.length, 1);
      expect(list[0].id, 2);
    });

    test('findFavouritesBySection returns empty when no favorites', () async {
      final result = await repo.findFavouritesBySection(sectionEN);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      expect((result as Ok).value, isEmpty);
    });

    test('findLastAccessedBySection returns most recently accessed', () async {
      final result = await repo.findLastAccessedBySection(sectionPT);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      final list = (result as Ok).value;
      expect(list.length, 1);
      expect(list[0].id, 2);
    });

    test('findLastAccessedBySection returns empty when none accessed', () async {
      final result = await repo.findLastAccessedBySection(sectionEN);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      expect((result as Ok).value, isEmpty);
    });

    test('findLastAccessedBySection respects limit', () async {
      final result = await repo.findLastAccessedBySection(sectionPT, limit: 1);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      expect((result as Ok).value.length, 1);
    });

    test('findMostAccessedBySection returns most accessed first', () async {
      final result = await repo.findMostAccessedBySection(sectionPT);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      final list = (result as Ok).value;
      expect(list.length, 4);
      expect(list[0].id, 2);
    });

    test('findMostAccessedBySection respects limit', () async {
      final result = await repo.findMostAccessedBySection(sectionPT, limit: 1);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      final list = (result as Ok).value;
      expect(list.length, 1);
      expect(list[0].id, 2);
    });

    test('findMostAccessedBySection returns empty for section with no hymns', () async {
      final result = await repo.findMostAccessedBySection(sectionEN);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      expect((result as Ok).value, isEmpty);
    });

    test('findNext returns next number in same section', () async {
      final current = HymnsNumber(id: 1, num: 1, code: '001', label: 'Hino 1', hymnsGroup: group1);
      final result = await repo.findNext(current);

      expect(result, isA<Ok<HymnsNumber?>>());
      final value = (result as Ok).value;
      expect(value, isNotNull);
      expect(value!.id, 2);
      expect(value.num, 2);
    });

    test('findNext returns null for last hymn', () async {
      final group2 = HymnsGroup(id: 2, name: 'Adoração', beginning: 51, finished: 100, section: sectionPT);
      final current = HymnsNumber(id: 5, num: 52, code: '052', label: 'Hino 52', hymnsGroup: group2);
      final result = await repo.findNext(current);

      expect(result, isA<Ok<HymnsNumber?>>());
      expect((result as Ok).value, isNull);
    });

    test('findPrevious returns previous number', () async {
      final current = HymnsNumber(id: 2, num: 2, code: '002', label: 'Hino 2', hymnsGroup: group1);
      final result = await repo.findPrevious(current);

      expect(result, isA<Ok<HymnsNumber?>>());
      final value = (result as Ok).value;
      expect(value, isNotNull);
      expect(value!.id, 1);
      expect(value.num, 1);
    });

    test('findPrevious returns null for first hymn', () async {
      final current = HymnsNumber(id: 1, num: 1, code: '001', label: 'Hino 1', hymnsGroup: group1);
      final result = await repo.findPrevious(current);

      expect(result, isA<Ok<HymnsNumber?>>());
      expect((result as Ok).value, isNull);
    });

    test('updateLastAccessed updates timestamp and increments count', () async {
      final beforeResult = await repo.findByHymnsGroup(group1);
      expect(beforeResult, isA<Ok<List<HymnsNumber>>>());
      final beforeList = (beforeResult as Ok).value;
      final before = beforeList.firstWhere((n) => n.id == 1);
      expect(before.accessCount, 0);
      expect(before.lastAccessedAt, isNull);

      final updateResult = await repo.updateLastAccessed(1);
      expect(updateResult, isA<Ok<void>>());

      final afterResult = await repo.findByHymnsGroup(group1);
      expect(afterResult, isA<Ok<List<HymnsNumber>>>());
      final afterList = (afterResult as Ok).value;
      final after = afterList.firstWhere((n) => n.id == 1);
      expect(after.accessCount, 1);
      expect(after.lastAccessedAt, isNotNull);
    });

    test('toggleFavorite toggles from 0 to 1', () async {
      final beforeResult = await repo.findByHymnsGroup(group1);
      expect(beforeResult, isA<Ok<List<HymnsNumber>>>());
      final beforeList = (beforeResult as Ok).value;
      expect(beforeList.firstWhere((n) => n.id == 1).isFavorite, isFalse);

      await repo.toggleFavorite(1);

      final afterResult = await repo.findByHymnsGroup(group1);
      expect(afterResult, isA<Ok<List<HymnsNumber>>>());
      final afterList = (afterResult as Ok).value;
      expect(afterList.firstWhere((n) => n.id == 1).isFavorite, isTrue);
    });

    test('toggleFavorite toggles from 1 to 0', () async {
      final beforeResult = await repo.findByHymnsGroup(group1);
      expect(beforeResult, isA<Ok<List<HymnsNumber>>>());
      final beforeList = (beforeResult as Ok).value;
      expect(beforeList.firstWhere((n) => n.id == 2).isFavorite, isTrue);

      await repo.toggleFavorite(2);

      final afterResult = await repo.findByHymnsGroup(group1);
      expect(afterResult, isA<Ok<List<HymnsNumber>>>());
      final afterList = (afterResult as Ok).value;
      expect(afterList.firstWhere((n) => n.id == 2).isFavorite, isFalse);
    });

    test('updateLastAccessed does not throw for non-existent id', () async {
      final result = await repo.updateLastAccessed(999);

      expect(result, isA<Ok<void>>());
    });

    test('toggleFavorite does not throw for non-existent id', () async {
      final result = await repo.toggleFavorite(999);

      expect(result, isA<Ok<void>>());
    });
  });
}
