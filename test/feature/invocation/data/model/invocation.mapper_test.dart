import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';

void main() {
  group('InvocationMapper', () {
    final section = SectionMapper.empty();

    group('toMapper', () {
      test('should map all fields correctly', () {
        final row = <String, Object?>{
          'id': 1,
          'name': 'Invocação 1',
          'position': 5,
          'is_favorite': 1,
          'access_count': 10,
          'last_accessed_at': 1700000000000,
        };
        final result = InvocationMapper.toMapper(row, section);
        expect(result.id, 1);
        expect(result.name, 'Invocação 1');
        expect(result.position, 5);
        expect(result.isFavorite, true);
        expect(result.accessCount, 10);
        expect(result.lastAccessedAt, DateTime.fromMillisecondsSinceEpoch(1700000000000));
        expect(result.section, same(section));
      });

      test('should handle last_accessed_at null when not in map', () {
        final row = <String, Object?>{
          'id': 2,
          'name': 'Invocation 2',
          'position': 3,
          'is_favorite': 0,
          'access_count': 5,
        };
        final result = InvocationMapper.toMapper(row, section);
        expect(result.lastAccessedAt, isNull);
      });

      test('should handle last_accessed_at explicitly null', () {
        final row = <String, Object?>{
          'id': 3,
          'name': 'Invocation 3',
          'position': 4,
          'is_favorite': 0,
          'access_count': 2,
          'last_accessed_at': null,
        };
        final result = InvocationMapper.toMapper(row, section);
        expect(result.lastAccessedAt, isNull);
      });

      test('should parse is_favorite 0 as false', () {
        final row = <String, Object?>{
          'id': 4,
          'name': 'Invocation 4',
          'position': 1,
          'is_favorite': 0,
          'access_count': 0,
        };
        final result = InvocationMapper.toMapper(row, section);
        expect(result.isFavorite, false);
      });

      test('should parse is_favorite 1 as true', () {
        final row = <String, Object?>{
          'id': 5,
          'name': 'Invocation 5',
          'position': 2,
          'is_favorite': 1,
          'access_count': 0,
        };
        final result = InvocationMapper.toMapper(row, section);
        expect(result.isFavorite, true);
      });

      test('should handle access_count 0', () {
        final row = <String, Object?>{
          'id': 6,
          'name': 'Invocation 6',
          'position': 6,
          'is_favorite': 0,
          'access_count': 0,
        };
        final result = InvocationMapper.toMapper(row, section);
        expect(result.accessCount, 0);
      });

      test('should handle access_count null and default to 0', () {
        final row = <String, Object?>{
          'id': 7,
          'name': 'Invocation 7',
          'position': 7,
          'is_favorite': 0,
        };
        final result = InvocationMapper.toMapper(row, section);
        expect(result.accessCount, 0);
      });

      test('should handle is_favorite null and default to false', () {
        final row = <String, Object?>{
          'id': 8,
          'name': 'Invocation 8',
          'position': 8,
          'access_count': 0,
        };
        final result = InvocationMapper.toMapper(row, section);
        expect(result.isFavorite, false);
      });
    });

    group('empty', () {
      test('should return default values', () {
        final result = InvocationMapper.empty();
        expect(result.id, 0);
        expect(result.name, '');
        expect(result.position, 0);
        expect(result.isFavorite, false);
        expect(result.accessCount, 0);
        expect(result.lastAccessedAt, isNull);
      });
    });
  });

  group('InvocationContentMapper', () {
    final invocation = InvocationMapper.empty();

    group('toMapper', () {
      test('should map all fields correctly including books', () {
        final row = <String, Object?>{
          'id': 1,
          'content': 'Texto 1',
          'position': 2,
          'books': 'Sl 23',
        };
        final result = InvocationContentMapper.toMapper(row, invocation);
        expect(result.id, 1);
        expect(result.content, 'Texto 1');
        expect(result.position, 2);
        expect(result.books, 'Sl 23');
        expect(result.invocation, same(invocation));
      });

      test('should map fields when books is null', () {
        final row = <String, Object?>{
          'id': 2,
          'content': 'Texto 2',
          'position': 1,
          'books': null,
        };
        expect(
          () => InvocationContentMapper.toMapper(row, invocation),
          throwsA(isA<TypeError>()),
        );
      });

      test('should map fields when books is not in map', () {
        final row = <String, Object?>{
          'id': 3,
          'content': 'Texto 3',
          'position': 3,
        };
        expect(
          () => InvocationContentMapper.toMapper(row, invocation),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('empty', () {
      test('should return default values', () {
        final result = InvocationContentMapper.empty();
        expect(result.id, 0);
        expect(result.content, '');
        expect(result.books, '');
        expect(result.position, 0);
        expect(result.invocation.id, 0);
      });
    });
  });
}
