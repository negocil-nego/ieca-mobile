import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';

void main() {
  group('PsalmsMapper', () {
    final section = SectionMapper.empty();

    test('empty returns default values', () {
      final result = PsalmsMapper.empty();

      expect(result.id, 0);
      expect(result.name, '');
      expect(result.position, 0);
      expect(result.section.id, section.id);
      expect(result.lastAccessedAt, isNull);
      expect(result.isFavorite, false);
      expect(result.accessCount, 0);
    });

    test('toMapper parses row correctly', () {
      final row = <String, Object?>{
        'id': 1,
        'name': 'Salmos 1',
        'position': 2,
        'last_accessed_at': 1700000000000,
        'is_favorite': 1,
        'access_count': 5,
      };

      final result = PsalmsMapper.toMapper(row, section);

      expect(result.id, 1);
      expect(result.name, 'Salmos 1');
      expect(result.position, 2);
      expect(result.section.id, section.id);
      expect(result.lastAccessedAt,
          DateTime.fromMillisecondsSinceEpoch(1700000000000));
      expect(result.isFavorite, true);
      expect(result.accessCount, 5);
    });

    test('toMapper handles null last_accessed_at', () {
      final row = <String, Object?>{
        'id': 1,
        'name': 'Salmos 1',
        'position': 1,
        'last_accessed_at': null,
        'is_favorite': 0,
        'access_count': 0,
      };

      final result = PsalmsMapper.toMapper(row, section);

      expect(result.lastAccessedAt, isNull);
    });

    test('toMapper handles is_favorite false', () {
      final row = <String, Object?>{
        'id': 1,
        'name': 'Salmos 1',
        'position': 1,
        'last_accessed_at': null,
        'is_favorite': 0,
        'access_count': 0,
      };

      final result = PsalmsMapper.toMapper(row, section);

      expect(result.isFavorite, false);
    });

    test('toMapper handles is_favorite true', () {
      final row = <String, Object?>{
        'id': 1,
        'name': 'Salmos 1',
        'position': 1,
        'last_accessed_at': null,
        'is_favorite': 1,
        'access_count': 0,
      };

      final result = PsalmsMapper.toMapper(row, section);

      expect(result.isFavorite, true);
    });

    test('toMapper handles null access_count', () {
      final row = <String, Object?>{
        'id': 1,
        'name': 'Salmos 1',
        'position': 1,
        'last_accessed_at': null,
        'is_favorite': 0,
        'access_count': null,
      };

      final result = PsalmsMapper.toMapper(row, section);

      expect(result.accessCount, 0);
    });

    test('toMapper handles null is_favorite', () {
      final row = <String, Object?>{
        'id': 1,
        'name': 'Salmos 1',
        'position': 1,
        'last_accessed_at': null,
        'is_favorite': null,
        'access_count': 0,
      };

      final result = PsalmsMapper.toMapper(row, section);

      expect(result.isFavorite, false);
    });
  });

  group('PsalmsContentMapper', () {
    final psalm = PsalmsMapper.empty();

    test('empty returns default values', () {
      final result = PsalmsContentMapper.empty();

      expect(result.id, 0);
      expect(result.person, '');
      expect(result.content, '');
      expect(result.position, 0);
      expect(result.psalm.id, psalm.id);
    });

    test('toMapper parses row correctly', () {
      final row = <String, Object?>{
        'id': 1,
        'person': 'David',
        'content': content,
        'position': 1,
        'psalm_id': 1,
      };

      final result = PsalmsContentMapper.toMapper(row, psalm);

      expect(result.id, 1);
      expect(result.person, 'David');
      expect(result.content, content);
      expect(result.position, 1);
      expect(result.psalm.id, psalm.id);
    });
  });
}

const content = 'O Senhor é o meu pastor, nada me faltará.';
