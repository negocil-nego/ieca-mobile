import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:mobile/_import.dart';

void main() {
  late String dbPath;
  late PsalmSqliteRepo repo;
  late Section section;
  late PsalmsTitle psalm1;
  late PsalmsTitle psalm2;
  late PsalmsTitle psalm3;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    dbPath = p.join(await getDatabasesPath(), 'app.db');
    try {
      await databaseFactory.deleteDatabase(dbPath);
    } catch (_) {}

    final db = await openDatabase(dbPath);

    await db.execute('''
      CREATE TABLE tb_sections (
        id INTEGER PRIMARY KEY,
        code TEXT NOT NULL,
        name TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE tb_psalms_title (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        position INTEGER NOT NULL,
        section_id INTEGER NOT NULL,
        last_accessed_at INTEGER,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        access_count INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE tb_psalms_content (
        id INTEGER PRIMARY KEY,
        person TEXT NOT NULL,
        content TEXT NOT NULL,
        position INTEGER NOT NULL,
        psalms_title_id INTEGER NOT NULL
      )
    ''');

    await db.insert('tb_sections', {
      'id': 1,
      'code': 'PT',
      'name': 'Português',
      'is_active': 1,
    });

    await db.insert('tb_psalms_title', {
      'id': 1,
      'name': 'Salmos 1',
      'position': 1,
      'section_id': 1,
      'last_accessed_at': 1000000,
      'is_favorite': 1,
      'access_count': 5,
    });

    await db.insert('tb_psalms_title', {
      'id': 2,
      'name': 'Salmos 2',
      'position': 2,
      'section_id': 1,
      'last_accessed_at': null,
      'is_favorite': 0,
      'access_count': 3,
    });

    await db.insert('tb_psalms_title', {
      'id': 3,
      'name': 'Salmos 3',
      'position': 3,
      'section_id': 1,
      'last_accessed_at': 2000000,
      'is_favorite': 0,
      'access_count': 10,
    });

    await db.insert('tb_psalms_content', {
      'id': 1,
      'person': 'David',
      'content': content1,
      'position': 1,
      'psalms_title_id': 1,
    });

    await db.insert('tb_psalms_content', {
      'id': 2,
      'person': 'David',
      'content': content2,
      'position': 2,
      'psalms_title_id': 1,
    });

    await db.insert('tb_psalms_content', {
      'id': 3,
      'person': 'Salmista',
      'content': searchable,
      'position': 1,
      'psalms_title_id': 2,
    });

    await db.close();

    repo = PsalmSqliteRepo();
    section = Section(
      id: 1,
      code: 'PT',
      name: 'Português',
      isActive: 1,
    );

    psalm1 = PsalmsMapper.toMapper({
      'id': 1,
      'name': 'Salmos 1',
      'position': 1,
      'last_accessed_at': 1000000,
      'is_favorite': 1,
      'access_count': 5,
    }, section);

    psalm2 = PsalmsMapper.toMapper({
      'id': 2,
      'name': 'Salmos 2',
      'position': 2,
      'last_accessed_at': null,
      'is_favorite': 0,
      'access_count': 3,
    }, section);

    psalm3 = PsalmsMapper.toMapper({
      'id': 3,
      'name': 'Salmos 3',
      'position': 3,
      'last_accessed_at': 2000000,
      'is_favorite': 0,
      'access_count': 10,
    }, section);
  });

  tearDown(() async {
    try {
      await databaseFactory.deleteDatabase(dbPath);
    } catch (_) {}
  });

  group('count', () {
    test('returns total number of psalms', () async {
      final result = await repo.count();
      expect(result, 3);
    });

    test('returns 0 when table is empty', () async {
      try {
        await databaseFactory.deleteDatabase(dbPath);
      } catch (_) {}

      final emptyDb = await openDatabase(dbPath);
      await emptyDb.execute('''
        CREATE TABLE tb_psalms_title (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          position INTEGER NOT NULL,
          section_id INTEGER NOT NULL,
          last_accessed_at INTEGER,
          is_favorite INTEGER NOT NULL DEFAULT 0,
          access_count INTEGER NOT NULL DEFAULT 0
        )
      ''');
      await emptyDb.close();

      final result = await repo.count();
      expect(result, 0);
    });

    test('returns 0 on error', () async {
      try {
        await databaseFactory.deleteDatabase(dbPath);
      } catch (_) {}

      final result = await repo.count();
      expect(result, 0);
    });
  });

  group('countBySection', () {
    test('returns count for section', () async {
      final result = await repo.countBySection(section);
      expect(result, 3);
    });

    test('returns 0 for section with no psalms', () async {
      final otherSection = Section(id: 2, code: 'EN', name: 'English');
      final result = await repo.countBySection(otherSection);
      expect(result, 0);
    });
  });

  group('findBySection', () {
    test('returns psalms ordered by position', () async {
      final result = await repo.findBySection(section);

      result.when(
        ok: (titles) {
          expect(titles.length, 3);
          expect(titles[0].id, 1);
          expect(titles[0].name, 'Salmos 1');
          expect(titles[0].position, 1);
          expect(titles[1].id, 2);
          expect(titles[1].position, 2);
          expect(titles[2].id, 3);
          expect(titles[2].position, 3);
        },
        error: (_) => fail('Expected ok result'),
      );
    });

    test('returns empty list for section with no psalms', () async {
      final otherSection = Section(id: 2, code: 'EN', name: 'English');
      final result = await repo.findBySection(otherSection);

      result.when(
        ok: (titles) => expect(titles, isEmpty),
        error: (_) => fail('Expected ok result'),
      );
    });
  });

  group('findContentByPsalmsTitle', () {
    test('returns content ordered by position', () async {
      final result = await repo.findContentByPsalmsTitle(psalm1);

      result.when(
        ok: (contents) {
          expect(contents.length, 2);
          expect(contents[0].id, 1);
          expect(contents[0].person, 'David');
          expect(contents[0].position, 1);
          expect(contents[1].id, 2);
          expect(contents[1].position, 2);
        },
        error: (_) => fail('Expected ok result'),
      );
    });

    test('returns empty list for psalm with no content', () async {
      final result = await repo.findContentByPsalmsTitle(psalm3);

      result.when(
        ok: (contents) => expect(contents, isEmpty),
        error: (_) => fail('Expected ok result'),
      );
    });
  });

  group('findContentFist', () {
    test('returns first content', () async {
      final result = await repo.findContentFist(psalm1);

      result.when(
        ok: (content) {
          expect(content.id, 1);
          expect(content.person, 'David');
          expect(content.position, 1);
        },
        error: (_) => fail('Expected ok result'),
      );
    });

    test('returns error when no content exists', () async {
      final result = await repo.findContentFist(psalm3);

      result.when(
        ok: (_) => fail('Expected error result'),
        error: (_) => expect(true, isTrue),
      );
    });
  });

  group('findLastAccessedBySection', () {
    test('returns psalms with access ordered by last_accessed_at desc',
        () async {
      final result = await repo.findLastAccessedBySection(section);

      result.when(
        ok: (titles) {
          expect(titles.length, 2);
          expect(titles[0].id, 3);
          expect(titles[1].id, 1);
        },
        error: (_) => fail('Expected ok result'),
      );
    });

    test('respects limit parameter', () async {
      final result =
          await repo.findLastAccessedBySection(section, limit: 1);

      result.when(
        ok: (titles) {
          expect(titles.length, 1);
          expect(titles[0].id, 3);
        },
        error: (_) => fail('Expected ok result'),
      );
    });
  });

  group('findMostAccessedBySection', () {
    test('returns psalms ordered by access_count desc', () async {
      final result = await repo.findMostAccessedBySection(section);

      result.when(
        ok: (titles) {
          expect(titles.length, 3);
          expect(titles[0].id, 3);
          expect(titles[0].accessCount, 10);
          expect(titles[1].id, 1);
          expect(titles[1].accessCount, 5);
          expect(titles[2].id, 2);
          expect(titles[2].accessCount, 3);
        },
        error: (_) => fail('Expected ok result'),
      );
    });

    test('respects limit parameter', () async {
      final result =
          await repo.findMostAccessedBySection(section, limit: 2);

      result.when(
        ok: (titles) {
          expect(titles.length, 2);
          expect(titles[0].id, 3);
          expect(titles[1].id, 1);
        },
        error: (_) => fail('Expected ok result'),
      );
    });
  });

  group('search', () {
    test('returns matching psalms via content LIKE', () async {
      final result = await repo.search(searchable, section);

      result.when(
        ok: (titles) {
          expect(titles.length, 1);
          expect(titles[0].id, 2);
        },
        error: (_) => fail('Expected ok result'),
      );
    });

    test('returns empty list when no match', () async {
      final result = await repo.search('zzzznonexistent', section);

      result.when(
        ok: (titles) => expect(titles, isEmpty),
        error: (_) => fail('Expected ok result'),
      );
    });
  });

  group('findFavouritesBySection', () {
    test('returns favorite psalms ordered by position', () async {
      final result = await repo.findFavouritesBySection(section);

      result.when(
        ok: (titles) {
          expect(titles.length, 1);
          expect(titles[0].id, 1);
          expect(titles[0].isFavorite, true);
        },
        error: (_) => fail('Expected ok result'),
      );
    });

    test('returns empty list when no favorites', () async {
      final otherSection = Section(id: 2, code: 'EN', name: 'English');
      final result = await repo.findFavouritesBySection(otherSection);

      result.when(
        ok: (titles) => expect(titles, isEmpty),
        error: (_) => fail('Expected ok result'),
      );
    });
  });

  group('findNext', () {
    test('returns next psalm by position', () async {
      final result = await repo.findNext(psalm1);

      result.when(
        ok: (title) {
          expect(title, isNotNull);
          expect(title!.id, 2);
          expect(title.position, 2);
        },
        error: (_) => fail('Expected ok result'),
      );
    });

    test('returns null when no next psalm', () async {
      final result = await repo.findNext(psalm3);

      result.when(
        ok: (title) => expect(title, isNull),
        error: (_) => fail('Expected ok result'),
      );
    });
  });

  group('findPrevious', () {
    test('returns previous psalm by position', () async {
      final result = await repo.findPrevious(psalm2);

      result.when(
        ok: (title) {
          expect(title, isNotNull);
          expect(title!.id, 1);
          expect(title.position, 1);
        },
        error: (_) => fail('Expected ok result'),
      );
    });

    test('returns null when no previous psalm', () async {
      final result = await repo.findPrevious(psalm1);

      result.when(
        ok: (title) => expect(title, isNull),
        error: (_) => fail('Expected ok result'),
      );
    });
  });

  group('updateLastAccessed', () {
    test('updates last_accessed_at and increments access_count', () async {
      await repo.updateLastAccessed(1);

      final db = await openDatabase(dbPath);
      final rows = await db.query('tb_psalms_title', where: 'id = 1');
      await db.close();

      expect(rows.length, 1);
      expect(rows.first['access_count'], 6);
      expect(rows.first['last_accessed_at'], isNotNull);
    });
  });

  group('toggleFavorite', () {
    test('toggles is_favorite from 1 to 0', () async {
      await repo.toggleFavorite(1);

      final db = await openDatabase(dbPath);
      final rows = await db.query('tb_psalms_title', where: 'id = 1');
      await db.close();

      expect(rows.length, 1);
      expect(rows.first['is_favorite'], 0);
    });

    test('toggles is_favorite from 0 to 1', () async {
      await repo.toggleFavorite(2);

      final db = await openDatabase(dbPath);
      final rows = await db.query('tb_psalms_title', where: 'id = 2');
      await db.close();

      expect(rows.length, 1);
      expect(rows.first['is_favorite'], 1);
    });
  });
}

const content1 = 'O Senhor é o meu pastor, nada me faltará.';
const content2 = 'Deitar-me faz em verdes pastos.';
const searchable = 'Conteúdo para busca de salmos.';
