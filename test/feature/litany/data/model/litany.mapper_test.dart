import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';

void main() {
  group('LitanyMapper', () {
    test('empty returns default values', () {
      final result = LitanyMapper.empty();

      expect(result.id, 0);
      expect(result.name, '');
      expect(result.position, 0);
      expect(result.section.id, 1);
      expect(result.lastAccessedAt, isNull);
      expect(result.isFavorite, false);
      expect(result.accessCount, 0);
    });

    test('toMapper parses row with all fields', () {
      final section = SectionMapper.empty();
      final row = <String, Object?>{
        'id': 1,
        'name': 'Litany of the Holy Spirit',
        'position': 3,
        'last_accessed_at': 1700000000000,
        'is_favorite': 1,
        'access_count': 5,
      };

      final result = LitanyMapper.toMapper(row, section);

      expect(result.id, 1);
      expect(result.name, 'Litany of the Holy Spirit');
      expect(result.position, 3);
      expect(result.section, same(section));
      expect(result.lastAccessedAt, DateTime.fromMillisecondsSinceEpoch(1700000000000));
      expect(result.isFavorite, true);
      expect(result.accessCount, 5);
    });

    test('toMapper handles null last_accessed_at', () {
      final section = SectionMapper.empty();
      final row = <String, Object?>{
        'id': 2,
        'name': 'Litany',
        'position': 1,
        'last_accessed_at': null,
        'is_favorite': 0,
        'access_count': 0,
      };

      final result = LitanyMapper.toMapper(row, section);

      expect(result.lastAccessedAt, isNull);
      expect(result.isFavorite, false);
      expect(result.accessCount, 0);
    });

    test('toMapper handles missing last_accessed_at key', () {
      final section = SectionMapper.empty();
      final row = <String, Object?>{
        'id': 3,
        'name': 'Litany',
        'position': 2,
        'is_favorite': 1,
        'access_count': 10,
      };

      final result = LitanyMapper.toMapper(row, section);

      expect(result.lastAccessedAt, isNull);
      expect(result.isFavorite, true);
      expect(result.accessCount, 10);
    });

    test('toMapper handles missing access_count key', () {
      final section = SectionMapper.empty();
      final row = <String, Object?>{
        'id': 4,
        'name': 'Litany',
        'position': 4,
        'last_accessed_at': null,
        'is_favorite': 0,
      };

      final result = LitanyMapper.toMapper(row, section);

      expect(result.accessCount, 0);
    });

    test('toMapper interprets is_favorite as boolean', () {
      final section = SectionMapper.empty();

      final rowTrue = <String, Object?>{
        'id': 1, 'name': 'A', 'position': 1,
        'last_accessed_at': null, 'is_favorite': 1, 'access_count': 0,
      };
      final rowFalse = <String, Object?>{
        'id': 2, 'name': 'B', 'position': 2,
        'last_accessed_at': null, 'is_favorite': 0, 'access_count': 0,
      };

      expect(LitanyMapper.toMapper(rowTrue, section).isFavorite, true);
      expect(LitanyMapper.toMapper(rowFalse, section).isFavorite, false);
    });
  });

  group('LitanyContentMapper', () {
    test('empty returns default values', () {
      final result = LitanyContentMapper.empty();

      expect(result.id, 0);
      expect(result.person, '');
      expect(result.content, '');
      expect(result.books, '');
      expect(result.litany.id, 0);
    });

    test('toMapper parses row with all fields', () {
      final litany = LitanyMapper.empty();
      final row = <String, Object?>{
        'id': 1,
        'person': 'Leader',
        'content': 'Lord, have mercy on us',
        'books': 'John 3:16',
      };

      final result = LitanyContentMapper.toMapper(row, litany);

      expect(result.id, 1);
      expect(result.person, 'Leader');
      expect(result.content, 'Lord, have mercy on us');
      expect(result.books, 'John 3:16');
      expect(result.litany, same(litany));
    });

    test('toMapper handles null books', () {
      final litany = LitanyMapper.empty();
      final row = <String, Object?>{
        'id': 2,
        'person': 'Response',
        'content': 'Christ, have mercy on us',
        'books': null,
      };

      final result = LitanyContentMapper.toMapper(row, litany);

      expect(result.books, isNull);
    });

    test('toMapper handles missing books key', () {
      final litany = LitanyMapper.empty();
      final row = <String, Object?>{
        'id': 3,
        'person': 'All',
        'content': 'Have mercy on us',
      };

      final result = LitanyContentMapper.toMapper(row, litany);

      expect(result.books, isNull);
    });

    test('toMapper preserves litany reference', () {
      final section = SectionMapper.empty();
      final litany = LitanyTitle(
        id: 42,
        name: 'Test Litany',
        position: 1,
        section: section,
        lastAccessedAt: null,
        isFavorite: true,
        accessCount: 7,
      );
      final row = <String, Object?>{
        'id': 10,
        'person': 'P',
        'content': 'C',
        'books': null,
      };

      final result = LitanyContentMapper.toMapper(row, litany);

      expect(result.litany.id, 42);
      expect(result.litany.name, 'Test Litany');
      expect(result.litany.isFavorite, true);
      expect(result.litany.accessCount, 7);
    });
  });
}
