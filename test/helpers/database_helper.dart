import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> createTestDatabase() async {
  sqfliteFfiInit();
  final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

  await db.execute('''
    CREATE TABLE tb_sections (
      id INTEGER PRIMARY KEY,
      code TEXT NOT NULL,
      name TEXT NOT NULL,
      is_active INTEGER NOT NULL DEFAULT 0
    )
  ''');

  await db.execute('''
    CREATE TABLE tb_hymns_group (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      beginning INTEGER NOT NULL,
      finished INTEGER NOT NULL,
      section_id INTEGER NOT NULL,
      FOREIGN KEY (section_id) REFERENCES tb_sections(id)
    )
  ''');

  await db.execute('''
    CREATE TABLE tb_hymns_number (
      id INTEGER PRIMARY KEY,
      num INTEGER NOT NULL,
      code TEXT NOT NULL,
      label TEXT NOT NULL,
      type TEXT NOT NULL DEFAULT 'NORMAL',
      hymns_group_id INTEGER NOT NULL,
      last_accessed_at INTEGER,
      is_favorite INTEGER NOT NULL DEFAULT 0,
      access_count INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (hymns_group_id) REFERENCES tb_hymns_group(id)
    )
  ''');

  await db.execute('''
    CREATE TABLE tb_hymns_content (
      id INTEGER PRIMARY KEY,
      position INTEGER NOT NULL,
      content TEXT NOT NULL,
      type_stanza TEXT NOT NULL DEFAULT 'VERSE',
      lang TEXT NOT NULL,
      hymns_number_id INTEGER NOT NULL,
      FOREIGN KEY (hymns_number_id) REFERENCES tb_hymns_number(id)
    )
  ''');

  await db.execute('''
    CREATE TABLE tb_invocation (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      position INTEGER NOT NULL,
      section_id INTEGER NOT NULL,
      last_accessed_at INTEGER,
      is_favorite INTEGER NOT NULL DEFAULT 0,
      access_count INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (section_id) REFERENCES tb_sections(id)
    )
  ''');

  await db.execute('''
    CREATE TABLE tb_invocation_content (
      id INTEGER PRIMARY KEY,
      content TEXT NOT NULL,
      position INTEGER NOT NULL,
      books TEXT,
      invocation_id INTEGER NOT NULL,
      FOREIGN KEY (invocation_id) REFERENCES tb_invocation(id)
    )
  ''');

  await db.execute('''
    CREATE TABLE tb_litany (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      position INTEGER NOT NULL,
      section_id INTEGER NOT NULL,
      last_accessed_at INTEGER,
      is_favorite INTEGER NOT NULL DEFAULT 0,
      access_count INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (section_id) REFERENCES tb_sections(id)
    )
  ''');

  await db.execute('''
    CREATE TABLE tb_litany_content (
      id INTEGER PRIMARY KEY,
      person TEXT NOT NULL,
      content TEXT NOT NULL,
      books TEXT,
      litany_id INTEGER NOT NULL,
      FOREIGN KEY (litany_id) REFERENCES tb_litany(id)
    )
  ''');

  await db.execute('''
    CREATE TABLE tb_psalms (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      position INTEGER NOT NULL,
      section_id INTEGER NOT NULL,
      last_accessed_at INTEGER,
      is_favorite INTEGER NOT NULL DEFAULT 0,
      access_count INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (section_id) REFERENCES tb_sections(id)
    )
  ''');

  await db.execute('''
    CREATE TABLE tb_psalms_content (
      id INTEGER PRIMARY KEY,
      person TEXT NOT NULL,
      content TEXT NOT NULL,
      position INTEGER NOT NULL,
      psalm_id INTEGER NOT NULL,
      FOREIGN KEY (psalm_id) REFERENCES tb_psalms(id)
    )
  ''');

  return db;
}

/// Creates a real database file at the path where openAppDatabase() expects it,
/// and returns the Database instance. Use this for testing repositories
/// that call openAppDatabase() internally.
Future<String> setupOnDiskTestDatabase() async {
  sqfliteFfiInit();
  final dbPath = p.join(await databaseFactoryFfi.getDatabasesPath(), 'app.db');
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
  await db.execute('''
    CREATE TABLE tb_invocation (
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
      invocation_id INTEGER NOT NULL
    )
  ''');
  await db.execute('''
    CREATE TABLE tb_litany (
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
      litany_id INTEGER NOT NULL
    )
  ''');
  await db.execute('''
    CREATE TABLE tb_psalms (
      id INTEGER PRIMARY KEY, name TEXT NOT NULL,
      position INTEGER NOT NULL, section_id INTEGER NOT NULL,
      last_accessed_at INTEGER,
      is_favorite INTEGER NOT NULL DEFAULT 0,
      access_count INTEGER NOT NULL DEFAULT 0
    )
  ''');
  await db.execute('''
    CREATE TABLE tb_psalms_content (
      id INTEGER PRIMARY KEY, person TEXT NOT NULL,
      content TEXT NOT NULL, position INTEGER NOT NULL,
      psalm_id INTEGER NOT NULL
    )
  ''');

  await db.close();
  return dbPath;
}
