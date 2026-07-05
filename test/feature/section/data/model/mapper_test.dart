import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';

void main() {
  group('SectionMapper', () {
    group('toMapper', () {
      test('should map all fields correctly when is_active = 1', () {
        final row = <String, Object?>{
          'id': 1,
          'code': 'PT',
          'name': 'Português',
          'is_active': 1,
        };

        final section = SectionMapper.toMapper(row);

        expect(section.id, 1);
        expect(section.code, 'PT');
        expect(section.name, 'Português');
        expect(section.isActive, 1);
      });

      test('should map all fields correctly when is_active = 0', () {
        final row = <String, Object?>{
          'id': 2,
          'code': 'EN',
          'name': 'English',
          'is_active': 0,
        };

        final section = SectionMapper.toMapper(row);

        expect(section.id, 2);
        expect(section.code, 'EN');
        expect(section.name, 'English');
        expect(section.isActive, 0);
      });

      test('should handle null values in row map', () {
        final row = <String, Object?>{
          'id': 3,
          'code': 'ES',
          'name': 'Español',
          'is_active': 1,
        };

        final section = SectionMapper.toMapper(row);

        expect(section.id, 3);
        expect(section.code, 'ES');
        expect(section.name, 'Español');
        expect(section.isActive, 1);
      });
    });

    group('empty', () {
      test('should return default Section with PT and isActive=1', () {
        final section = SectionMapper.empty();

        expect(section.id, 1);
        expect(section.code, 'PT');
        expect(section.name, 'Português');
        expect(section.isActive, 1);
      });

      test('should return a new instance each call', () {
        final first = SectionMapper.empty();
        final second = SectionMapper.empty();

        expect(identical(first, second), false);
        expect(first.id, second.id);
        expect(first.code, second.code);
        expect(first.name, second.name);
        expect(first.isActive, second.isActive);
      });
    });
  });
}
