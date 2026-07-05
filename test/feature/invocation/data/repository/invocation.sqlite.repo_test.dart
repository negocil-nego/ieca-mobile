import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:mobile/_import.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' show getDatabasesPath, openDatabase;
import 'package:path/path.dart' as p;
import '../../../../helpers/database_helper.dart';

DatabaseFactory get _ffiFactory => databaseFactoryFfi;

/// Opens the database at the standard path and recreates schema + data fresh.
Future<String> _resetTestDatabase() async {
  final dbPath = p.join(await _ffiFactory.getDatabasesPath(), 'app.db');
  final db = await _ffiFactory.openDatabase(dbPath);

  await db.execute('DROP TABLE IF EXISTS tb_invocation_content');
  await db.execute('DROP TABLE IF EXISTS tb_invocation_title');
  await db.execute('DROP TABLE IF EXISTS tb_sections');

  await db.execute('''
    CREATE TABLE tb_sections (
      id INTEGER PRIMARY KEY, code TEXT NOT NULL, name TEXT NOT NULL,
      is_active INTEGER NOT NULL DEFAULT 0
    )
  ''');
  await db.execute('''
    CREATE TABLE tb_invocation_title (
      id INTEGER PRIMARY KEY, name TEXT NOT NULL,
      position INTEGER NOT NULL, section_id INTEGER NOT NULL,
      last_accessed_at INTEGER,
      is_favorite INTEGER NOT NULL DEFAULT 0,
      access_count INTEGER NOT NULL DEFAULT 0
    )
  ''');
  await db.execute('''
    CREATE TABLE tb_invocation_content (
      id INTEGER PRIMARY KEY, content TEXT NOT NULL,
      position INTEGER NOT NULL, books TEXT,
      invocation_title_id INTEGER NOT NULL
    )
  ''');

  await db.insert('tb_sections', {'id': 1, 'code': 'PT', 'name': 'Português', 'is_active': 1});
  await db.insert('tb_sections', {'id': 2, 'code': 'EN', 'name': 'English', 'is_active': 1});
  await db.insert('tb_invocation_title', {'id': 1, 'name': 'Invocação 1', 'position': 1, 'section_id': 1, 'is_favorite': 0, 'access_count': 0});
  await db.insert('tb_invocation_title', {'id': 2, 'name': 'Invocação 2', 'position': 2, 'section_id': 1, 'is_favorite': 1, 'access_count': 3, 'last_accessed_at': 1000});
  await db.insert('tb_invocation_title', {'id': 3, 'name': 'Invocação 3', 'position': 3, 'section_id': 1, 'is_favorite': 0, 'access_count': 5, 'last_accessed_at': 2000});
  await db.insert('tb_invocation_title', {'id': 4, 'name': 'Other Section', 'position': 1, 'section_id': 2, 'is_favorite': 0, 'access_count': 1, 'last_accessed_at': 3000});
  await db.insert('tb_invocation_content', {'id': 1, 'content': 'Texto 1', 'position': 1, 'invocation_title_id': 1, 'books': ''});
  await db.insert('tb_invocation_content', {'id': 2, 'content': 'Texto 2', 'position': 2, 'invocation_title_id': 1, 'books': 'Sl 23'});
  await db.insert('tb_invocation_content', {'id': 3, 'content': 'Conteúdo 2', 'position': 1, 'invocation_title_id': 2, 'books': ''});

  return dbPath;
}

void main() {
  late Section section;
  late InvocationSqliteRepo repo;

  setUp(() async {
    if (!_sqfliteInitialized) {
      sqfliteFfiInit();
      databaseFactory = _ffiFactory;
      _sqfliteInitialized = true;
    }

    await _resetTestDatabase();

    section = Section(id: 1, code: 'PT', name: 'Português', isActive: 1);
    repo = InvocationSqliteRepo();
  });

  tearDown(() async {
  });

  group('count', () {
    test('should return total number of invocation titles', () async {
      final result = await repo.count();
      expect(result, 4);
    });

    test('should return 0 when table is empty', () async {
      final dbPath = p.join(await databaseFactoryFfi.getDatabasesPath(), 'app.db');
      final db = await databaseFactoryFfi.openDatabase(dbPath);
      await db.execute('DELETE FROM tb_invocation_content');
      await db.execute('DELETE FROM tb_invocation_title');
      await db.execute('DELETE FROM tb_sections');
      await db.close();

      final emptyRepo = InvocationSqliteRepo();
      expect(await emptyRepo.count(), 0);
    });
  });

  group('countBySection', () {
    test('should return count for given section', () async {
      final result = await repo.countBySection(section);
      expect(result, 3);
    });

    test('should return 0 for section with no invocations', () async {
      final otherSection = Section(id: 99, code: 'XX', name: 'Nonexistent', isActive: 0);
      final result = await repo.countBySection(otherSection);
      expect(result, 0);
    });
  });

  group('findBySection', () {
    test('should return all invocations for section ordered by position', () async {
      final result = await repo.findBySection(section);

      result.when(
        ok: (list) {
          expect(list.length, 3);
          expect(list[0].name, 'Invocação 1');
          expect(list[0].position, 1);
          expect(list[1].name, 'Invocação 2');
          expect(list[1].position, 2);
          expect(list[2].name, 'Invocação 3');
          expect(list[2].position, 3);
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should return correct section reference', () async {
      final result = await repo.findBySection(section);

      result.when(
        ok: (list) {
          for (final inv in list) {
            expect(inv.section.id, section.id);
          }
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should return empty list for section with no data', () async {
      final otherSection = Section(id: 99, code: 'XX', name: 'Nonexistent', isActive: 0);
      final result = await repo.findBySection(otherSection);

      result.when(
        ok: (list) => expect(list, isEmpty),
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('findContentByInvocation', () {
    test('should return all content for invocation ordered by position', () async {
      final invocations = await repo.findBySection(section);
      InvocationTitle? inv1;
      invocations.when(ok: (list) => inv1 = list[0], error: (_) {});

      final result = await repo.findContentByInvocation(inv1!);

      result.when(
        ok: (list) {
          expect(list.length, 2);
          expect(list[0].content, 'Texto 1');
          expect(list[0].position, 1);
          expect(list[1].content, 'Texto 2');
          expect(list[1].position, 2);
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should include books when present', () async {
      final invocations = await repo.findBySection(section);
      InvocationTitle? inv1;
      invocations.when(ok: (list) => inv1 = list[0], error: (_) {});

      final result = await repo.findContentByInvocation(inv1!);

      result.when(
        ok: (list) {
          expect(list[0].books, '');
          expect(list[1].books, 'Sl 23');
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should return empty list when no content', () async {
      final emptyInvocation = InvocationTitle(id: 999, name: 'Empty', position: 99, section: section);
      final result = await repo.findContentByInvocation(emptyInvocation);

      result.when(
        ok: (list) => expect(list, isEmpty),
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('findContentFist', () {
    test('should return first content ordered by position', () async {
      final invocations = await repo.findBySection(section);
      InvocationTitle? inv1;
      invocations.when(ok: (list) => inv1 = list[0], error: (_) {});

      final result = await repo.findContentFist(inv1!);

      result.when(
        ok: (content) {
          expect(content.content, 'Texto 1');
          expect(content.position, 1);
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should return error when no content found', () async {
      final emptyInvocation = InvocationTitle(id: 999, name: 'Empty', position: 99, section: section);
      final result = await repo.findContentFist(emptyInvocation);

      result.when(
        ok: (_) => fail('should be error'),
        error: (_) => expect(true, isTrue),
      );
    });
  });

  group('findLastAccessedBySection', () {
    test('should return invocations ordered by last_accessed_at desc', () async {
      final result = await repo.findLastAccessedBySection(section);

      result.when(
        ok: (list) {
          expect(list.length, 2);
          expect(list[0].name, 'Invocação 3');
          expect(list[1].name, 'Invocação 2');
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should respect limit parameter', () async {
      final result = await repo.findLastAccessedBySection(section, limit: 1);

      result.when(
        ok: (list) {
          expect(list.length, 1);
          expect(list[0].name, 'Invocação 3');
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should ignore invocations with null last_accessed_at', () async {
      final result = await repo.findLastAccessedBySection(section);

      result.when(
        ok: (list) {
          for (final inv in list) {
            expect(inv.lastAccessedAt, isNotNull);
          }
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should return empty list when no accessed invocations', () async {
      final otherSection = Section(id: 99, code: 'XX', name: 'Nonexistent', isActive: 0);
      final result = await repo.findLastAccessedBySection(otherSection);

      result.when(
        ok: (list) => expect(list, isEmpty),
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('findMostAccessedBySection', () {
    test('should return invocations ordered by access_count desc', () async {
      final result = await repo.findMostAccessedBySection(section);

      result.when(
        ok: (list) {
          expect(list.length, 3);
          expect(list[0].accessCount, 5);
          expect(list[0].name, 'Invocação 3');
          expect(list[1].accessCount, 3);
          expect(list[1].name, 'Invocação 2');
          expect(list[2].accessCount, 0);
          expect(list[2].name, 'Invocação 1');
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should respect limit parameter', () async {
      final result = await repo.findMostAccessedBySection(section, limit: 2);

      result.when(
        ok: (list) {
          expect(list.length, 2);
          expect(list[0].accessCount, 5);
          expect(list[1].accessCount, 3);
        },
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('search', () {
    test('should find invocations matching content', () async {
      final result = await repo.search('Texto', section);

      result.when(
        ok: (list) {
          expect(list.length, 1);
          expect(list[0].name, 'Invocação 1');
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should return empty list for no match', () async {
      final result = await repo.search('zzzzz', section);

      result.when(
        ok: (list) => expect(list, isEmpty),
        error: (_) => fail('should be ok'),
      );
    });

    test('should only search within the given section', () async {
      final result = await repo.search('Texto', section);

      result.when(
        ok: (list) {
          for (final inv in list) {
            expect(inv.section.id, section.id);
          }
        },
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('findFavouritesBySection', () {
    test('should return only favorite invocations for section', () async {
      final result = await repo.findFavouritesBySection(section);

      result.when(
        ok: (list) {
          expect(list.length, 1);
          expect(list[0].name, 'Invocação 2');
          expect(list[0].isFavorite, true);
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should return empty list when no favorites', () async {
      final otherSection = Section(id: 99, code: 'XX', name: 'Nonexistent', isActive: 0);
      final result = await repo.findFavouritesBySection(otherSection);

      result.when(
        ok: (list) => expect(list, isEmpty),
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('findNext', () {
    test('should return next invocation by position', () async {
      final current = InvocationTitle(id: 1, name: 'Invocação 1', position: 1, section: section);
      final result = await repo.findNext(current);

      result.when(
        ok: (next) {
          expect(next, isNotNull);
          expect(next!.name, 'Invocação 2');
          expect(next.position, 2);
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should return null when current is last', () async {
      final current = InvocationTitle(id: 3, name: 'Invocação 3', position: 3, section: section);
      final result = await repo.findNext(current);

      result.when(
        ok: (next) => expect(next, isNull),
        error: (_) => fail('should be ok'),
      );
    });

    test('should return null for non-existent position', () async {
      final current = InvocationTitle(id: 99, name: 'Ghost', position: 99, section: section);
      final result = await repo.findNext(current);

      result.when(
        ok: (next) => expect(next, isNull),
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('findPrevious', () {
    test('should return previous invocation by position', () async {
      final current = InvocationTitle(id: 2, name: 'Invocação 2', position: 2, section: section);
      final result = await repo.findPrevious(current);

      result.when(
        ok: (prev) {
          expect(prev, isNotNull);
          expect(prev!.name, 'Invocação 1');
          expect(prev.position, 1);
        },
        error: (_) => fail('should be ok'),
      );
    });

    test('should return null when current is first', () async {
      final current = InvocationTitle(id: 1, name: 'Invocação 1', position: 1, section: section);
      final result = await repo.findPrevious(current);

      result.when(
        ok: (prev) => expect(prev, isNull),
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('updateLastAccessed', () {
    test('should update last_accessed_at and increment access_count', () async {
      final before = await repo.findBySection(section);
      late int countBefore;
      before.when(
        ok: (list) => countBefore = list[0].accessCount,
        error: (_) => fail('should be ok'),
      );

      await repo.updateLastAccessed(1);

      final after = await repo.findBySection(section);
      after.when(
        ok: (list) {
          expect(list[0].accessCount, countBefore + 1);
          expect(list[0].lastAccessedAt, isNotNull);
        },
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('toggleFavorite', () {
    test('should toggle is_favorite from 0 to 1', () async {
      await repo.toggleFavorite(1);

      final result = await repo.findBySection(section);
      result.when(
        ok: (list) => expect(list[0].isFavorite, true),
        error: (_) => fail('should be ok'),
      );
    });

    test('should toggle is_favorite from 1 to 0', () async {
      await repo.toggleFavorite(2);

      final result = await repo.findBySection(section);
      result.when(
        ok: (list) => expect(list[1].isFavorite, false),
        error: (_) => fail('should be ok'),
      );
    });

    test('should toggle back to original after two calls', () async {
      await repo.toggleFavorite(1);
      await repo.toggleFavorite(1);

      final result = await repo.findBySection(section);
      result.when(
        ok: (list) => expect(list[0].isFavorite, false),
        error: (_) => fail('should be ok'),
      );
    });
  });
}

bool _sqfliteInitialized = false;
