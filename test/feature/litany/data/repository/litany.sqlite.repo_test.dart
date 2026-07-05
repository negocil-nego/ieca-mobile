import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Section section;
  late LitanyTitle litany1;
  late LitanyTitle litany2;
  late LitanyTitle litany3;
  late String dbPath;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    section = SectionMapper.empty();
    litany1 = LitanyTitle(
      id: 1, name: 'Litany of the Holy Spirit', position: 1, section: section,
      lastAccessedAt: DateTime.fromMillisecondsSinceEpoch(1000000),
      isFavorite: true, accessCount: 5,
    );
    litany2 = LitanyTitle(
      id: 2, name: 'Litany of the Sacred Heart', position: 2, section: section,
      lastAccessedAt: null, isFavorite: false, accessCount: 0,
    );
    litany3 = LitanyTitle(
      id: 3, name: 'Litany of the Blessed Virgin', position: 3, section: section,
      lastAccessedAt: DateTime.fromMillisecondsSinceEpoch(2000000),
      isFavorite: false, accessCount: 3,
    );

    dbPath = p.join(await databaseFactoryFfi.getDatabasesPath(), 'app.db');
    try {
      await databaseFactoryFfi.deleteDatabase(dbPath);
    } catch (_) {}
  });

  Future<void> setupDatabase() async {
    final db = await databaseFactoryFfi.openDatabase(dbPath);

    await db.execute('''
      CREATE TABLE tb_sections (
        id INTEGER PRIMARY KEY, code TEXT NOT NULL, name TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE tb_litany_title (
        id INTEGER PRIMARY KEY, name TEXT NOT NULL,
        position INTEGER NOT NULL, section_id INTEGER NOT NULL,
        last_accessed_at INTEGER,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        access_count INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE tb_litany_content (
        id INTEGER PRIMARY KEY, person TEXT NOT NULL,
        content TEXT NOT NULL, books TEXT,
        litany_title_id INTEGER NOT NULL
      )
    ''');

    await db.execute(
      'INSERT INTO tb_sections (id, code, name, is_active) VALUES (?, ?, ?, ?)',
      [section.id, section.code, section.name, section.isActive],
    );

    await db.execute(
      'INSERT INTO tb_litany_title (id, name, position, section_id, last_accessed_at, is_favorite, access_count) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [litany1.id, litany1.name, litany1.position, section.id,
       litany1.lastAccessedAt?.millisecondsSinceEpoch,
       litany1.isFavorite ? 1 : 0, litany1.accessCount],
    );
    await db.execute(
      'INSERT INTO tb_litany_title (id, name, position, section_id, last_accessed_at, is_favorite, access_count) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [litany2.id, litany2.name, litany2.position, section.id,
       litany2.lastAccessedAt?.millisecondsSinceEpoch,
       litany2.isFavorite ? 1 : 0, litany2.accessCount],
    );
    await db.execute(
      'INSERT INTO tb_litany_title (id, name, position, section_id, last_accessed_at, is_favorite, access_count) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [litany3.id, litany3.name, litany3.position, section.id,
       litany3.lastAccessedAt?.millisecondsSinceEpoch,
       litany3.isFavorite ? 1 : 0, litany3.accessCount],
    );

    await db.execute(
      'INSERT INTO tb_litany_content (id, person, content, books, litany_title_id) VALUES (?, ?, ?, ?, ?)',
      [1, 'Leader', 'Lord, have mercy on us', null, 1],
    );
    await db.execute(
      'INSERT INTO tb_litany_content (id, person, content, books, litany_title_id) VALUES (?, ?, ?, ?, ?)',
      [2, 'Response', 'Christ, have mercy on us', 'Some reference', 1],
    );

    await db.close();
  }

  tearDown(() async {
    try {
      await databaseFactoryFfi.deleteDatabase(dbPath);
    } catch (_) {}
  });

  test('count returns total number of litany titles', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.count();

    expect(result, 3);
  });

  test('countBySection returns count filtered by section', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.countBySection(section);

    expect(result, 3);
  });

  test('findBySection returns litany titles ordered by position', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findBySection(section);

    result.when(
      ok: (list) {
        expect(list.length, 3);
        expect(list[0].id, litany1.id);
        expect(list[0].name, litany1.name);
        expect(list[0].position, 1);
        expect(list[1].id, litany2.id);
        expect(list[1].position, 2);
        expect(list[2].id, litany3.id);
        expect(list[2].position, 3);
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('findContentByLitanyTitle returns content for given litany', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findContentByLitanyTitle(litany1);

    result.when(
      ok: (list) {
        expect(list.length, 2);
        expect(list[0].id, 1);
        expect(list[0].person, 'Leader');
        expect(list[0].content, 'Lord, have mercy on us');
        expect(list[0].books, isNull);
        expect(list[1].id, 2);
        expect(list[1].person, 'Response');
        expect(list[1].content, 'Christ, have mercy on us');
        expect(list[1].books, 'Some reference');
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('findContentByLitanyTitle returns empty list when litany has no content', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findContentByLitanyTitle(litany2);

    result.when(
      ok: (list) => expect(list, isEmpty),
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('findContentFist returns first content for litany', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findContentFist(litany1);

    result.when(
      ok: (content) {
        expect(content.id, 1);
        expect(content.person, 'Leader');
        expect(content.content, 'Lord, have mercy on us');
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('findContentFist returns error when no content exists', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findContentFist(litany2);

    result.when(
      ok: (_) => fail('Expected Error'),
      error: (_) => expect(true, isTrue),
    );
  });

  test('findLastAccessedBySection returns only litanies with last_accessed_at ordered DESC', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findLastAccessedBySection(section);

    result.when(
      ok: (list) {
        expect(list.length, 2);
        expect(list[0].id, litany3.id);
        expect(list[1].id, litany1.id);
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('findLastAccessedBySection respects limit', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findLastAccessedBySection(section, limit: 1);

    result.when(
      ok: (list) {
        expect(list.length, 1);
        expect(list[0].id, litany3.id);
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('findMostAccessedBySection returns litanies ordered by access_count DESC', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findMostAccessedBySection(section);

    result.when(
      ok: (list) {
        expect(list.length, 3);
        expect(list[0].id, litany1.id);
        expect(list[0].accessCount, 5);
        expect(list[1].id, litany3.id);
        expect(list[1].accessCount, 3);
        expect(list[2].id, litany2.id);
        expect(list[2].accessCount, 0);
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('search returns litanies matching content text', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.search('have mercy on us', section);

    result.when(
      ok: (list) {
        expect(list.length, 1);
        expect(list[0].id, litany1.id);
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('search returns distinct litanies when multiple content rows match', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.search('mercy', section);

    result.when(
      ok: (list) {
        expect(list.length, 1);
        expect(list[0].id, litany1.id);
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('search returns empty list when no content matches', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.search('nonexistent text', section);

    result.when(
      ok: (list) => expect(list, isEmpty),
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('findFavouritesBySection returns only favorite litanies', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findFavouritesBySection(section);

    result.when(
      ok: (list) {
        expect(list.length, 1);
        expect(list[0].id, litany1.id);
        expect(list[0].isFavorite, true);
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('findNext returns litany with next higher position', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findNext(litany1);

    result.when(
      ok: (next) {
        expect(next, isNotNull);
        expect(next!.id, litany2.id);
        expect(next.position, 2);
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('findNext returns null when at last position', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findNext(litany3);

    result.when(
      ok: (next) => expect(next, isNull),
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('findPrevious returns litany with next lower position', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findPrevious(litany2);

    result.when(
      ok: (prev) {
        expect(prev, isNotNull);
        expect(prev!.id, litany1.id);
        expect(prev.position, 1);
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('findPrevious returns null when at first position', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.findPrevious(litany1);

    result.when(
      ok: (prev) => expect(prev, isNull),
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('updateLastAccessed updates timestamp and increments access_count', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    final result = await repo.updateLastAccessed(litany2.id);

    result.when(
      ok: (_) => expect(true, isTrue),
      error: (e) => fail('Expected Ok but got Error: $e'),
    );

    final verifyResult = await repo.findBySection(section);
    verifyResult.when(
      ok: (list) {
        expect(list[1].accessCount, 1);
        expect(list[1].lastAccessedAt, isNotNull);
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('toggleFavorite toggles is_favorite flag from 1 to 0', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    await repo.toggleFavorite(litany1.id);

    final result = await repo.findBySection(section);
    result.when(
      ok: (list) {
        expect(list[0].isFavorite, false);
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });

  test('toggleFavorite toggles is_favorite flag from 0 to 1', () async {
    await setupDatabase();
    final repo = LitanySqliteRepo();

    await repo.toggleFavorite(litany2.id);

    final result = await repo.findBySection(section);
    result.when(
      ok: (list) {
        expect(list[1].isFavorite, true);
      },
      error: (e) => fail('Expected Ok but got Error: $e'),
    );
  });
}
