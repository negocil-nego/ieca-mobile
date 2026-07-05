import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../../../helpers/database_helper.dart';

void main() {
  late SectionSqliteRepo repo;

  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    await setupOnDiskTestDatabase();
    repo = SectionSqliteRepo();
  });

  tearDown(() async {
    final dbPath = p.join(await databaseFactory.getDatabasesPath(), 'app.db');
    await databaseFactory.deleteDatabase(dbPath);
  });

  group('SectionSqliteRepo', () {
    group('findAll', () {
      test('should return all sections ordered by name ASC', () async {
        final db = await openAppDatabase();
        await db.insert('tb_sections', {
          'id': 1,
          'code': 'PT',
          'name': 'Português',
          'is_active': 1,
        });
        await db.insert('tb_sections', {
          'id': 2,
          'code': 'EN',
          'name': 'English',
          'is_active': 0,
        });
        await db.insert('tb_sections', {
          'id': 3,
          'code': 'ES',
          'name': 'Español',
          'is_active': 0,
        });
        await db.close();

        final result = await repo.findAll();

        result.when(
          ok: (sections) {
            expect(sections, hasLength(3));
            expect(sections[0].name, 'English');
            expect(sections[1].name, 'Español');
            expect(sections[2].name, 'Português');
          },
          error: (_) => fail('Expected ok result'),
        );
      });

      test('should return empty list when table is empty', () async {
        final result = await repo.findAll();

        result.when(
          ok: (sections) => expect(sections, isEmpty),
          error: (_) => fail('Expected ok result'),
        );
      });
    });

    group('findDefault', () {
      test('should return error when no section is active', () async {
        final db = await openAppDatabase();
        await db.insert('tb_sections', {
          'id': 1,
          'code': 'PT',
          'name': 'Português',
          'is_active': 0,
        });
        await db.insert('tb_sections', {
          'id': 2,
          'code': 'EN',
          'name': 'English',
          'is_active': 0,
        });
        await db.close();

        final result = await repo.findDefault();

        result.when(
          ok: (_) => fail('Expected error result'),
          error: (e) => expect(
            e.toString(),
            contains('Nenhuma seção padrão encontrada'),
          ),
        );
      });

      test('should return the active section when one exists', () async {
        final db = await openAppDatabase();
        await db.insert('tb_sections', {
          'id': 1,
          'code': 'PT',
          'name': 'Português',
          'is_active': 1,
        });
        await db.insert('tb_sections', {
          'id': 2,
          'code': 'EN',
          'name': 'English',
          'is_active': 0,
        });
        await db.close();

        final result = await repo.findDefault();

        result.when(
          ok: (section) {
            expect(section.id, 1);
            expect(section.code, 'PT');
            expect(section.name, 'Português');
            expect(section.isActive, 1);
          },
          error: (_) => fail('Expected ok result'),
        );
      });

      test('should return first active section when multiple are active',
          () async {
        final db = await openAppDatabase();
        await db.insert('tb_sections', {
          'id': 1,
          'code': 'PT',
          'name': 'Português',
          'is_active': 1,
        });
        await db.insert('tb_sections', {
          'id': 2,
          'code': 'EN',
          'name': 'English',
          'is_active': 1,
        });
        await db.close();

        final result = await repo.findDefault();

        result.when(
          ok: (section) {
            expect(section.id, 1);
            expect(section.isActive, 1);
          },
          error: (_) => fail('Expected ok result'),
        );
      });
    });

    group('updateDefault', () {
      test('should deactivate all sections and activate the selected one',
          () async {
        final db = await openAppDatabase();
        await db.insert('tb_sections', {
          'id': 1,
          'code': 'PT',
          'name': 'Português',
          'is_active': 1,
        });
        await db.insert('tb_sections', {
          'id': 2,
          'code': 'EN',
          'name': 'English',
          'is_active': 0,
        });
        await db.close();

        final newDefault = Section(
          id: 2,
          code: 'EN',
          name: 'English',
          isActive: 1,
        );

        final result = await repo.updateDefault(newDefault);

        result.when(
          ok: (_) {},
          error: (_) => fail('Expected ok result'),
        );

        final verifyResult = await repo.findAll();
        verifyResult.when(
          ok: (sections) {
            final pt = sections.firstWhere((s) => s.id == 1);
            final en = sections.firstWhere((s) => s.id == 2);
            expect(pt.isActive, 0);
            expect(en.isActive, 1);
          },
          error: (_) => fail('Expected ok result'),
        );
      });

      test('should return ok even when updating to already active section',
          () async {
        final db = await openAppDatabase();
        await db.insert('tb_sections', {
          'id': 1,
          'code': 'PT',
          'name': 'Português',
          'is_active': 1,
        });
        await db.close();

        final sameDefault = Section(
          id: 1,
          code: 'PT',
          name: 'Português',
          isActive: 1,
        );

        final result = await repo.updateDefault(sameDefault);

        result.when(
          ok: (_) => expect(true, isTrue),
          error: (_) => fail('Expected ok result'),
        );

        final verifyResult = await repo.findAll();
        verifyResult.when(
          ok: (sections) {
            expect(sections.first.isActive, 1);
          },
          error: (_) => fail('Expected ok result'),
        );
      });
    });
  });
}
