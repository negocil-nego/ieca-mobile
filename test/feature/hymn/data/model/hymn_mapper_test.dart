import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';

void main() {
  group('HymnGroupMapper', () {
    test('toMapper maps all fields correctly', () {
      final section = SectionMapper.empty();
      final row = <String, Object?>{
        'id': 1,
        'name': 'Louvor',
        'beginning': 1,
        'finished': 50,
      };

      final result = HymnGroupMapper.toMapper(row, section);

      expect(result.id, 1);
      expect(result.name, 'Louvor');
      expect(result.beginning, 1);
      expect(result.finished, 50);
      expect(result.section, same(section));
    });

    test('empty returns default values', () {
      final result = HymnGroupMapper.empty();

      expect(result.id, 0);
      expect(result.name, '');
      expect(result.beginning, 0);
      expect(result.finished, 0);
      expect(result.section, isA<Section>());
    });
  });

  group('HymnNumberMapper', () {
    test('toMapper maps all fields with non-null last_accessed_at', () {
      final group = HymnGroupMapper.empty();
      final row = <String, Object?>{
        'id': 1,
        'num': 1,
        'code': '001',
        'label': 'Hino 1',
        'type': 'NORMAL',
        'hymns_group_id': 1,
        'last_accessed_at': 1000,
        'is_favorite': 1,
        'access_count': 5,
      };

      final result = HymnNumberMapper.toMapper(row, group);

      expect(result.id, 1);
      expect(result.num, 1);
      expect(result.code, '001');
      expect(result.label, 'Hino 1');
      expect(result.hymnsGroup, same(group));
      expect(result.lastAccessedAt, DateTime.fromMillisecondsSinceEpoch(1000));
      expect(result.isFavorite, isTrue);
      expect(result.accessCount, 5);
    });

    test('toMapper handles null last_accessed_at', () {
      final group = HymnGroupMapper.empty();
      final row = <String, Object?>{
        'id': 2,
        'num': 2,
        'code': '002',
        'label': 'Hino 2',
        'type': 'NORMAL',
        'hymns_group_id': 1,
        'last_accessed_at': null,
        'is_favorite': 0,
        'access_count': 0,
      };

      final result = HymnNumberMapper.toMapper(row, group);

      expect(result.id, 2);
      expect(result.lastAccessedAt, isNull);
      expect(result.isFavorite, isFalse);
      expect(result.accessCount, 0);
    });

    test('toMapper handles is_favorite = 0', () {
      final group = HymnGroupMapper.empty();
      final row = <String, Object?>{
        'id': 1, 'num': 1, 'code': '001', 'label': 'Hino 1',
        'type': 'NORMAL', 'hymns_group_id': 1,
        'last_accessed_at': null, 'is_favorite': 0, 'access_count': 0,
      };

      final result = HymnNumberMapper.toMapper(row, group);

      expect(result.isFavorite, isFalse);
    });

    test('toMapper handles is_favorite = 1', () {
      final group = HymnGroupMapper.empty();
      final row = <String, Object?>{
        'id': 1, 'num': 1, 'code': '001', 'label': 'Hino 1',
        'type': 'NORMAL', 'hymns_group_id': 1,
        'last_accessed_at': null, 'is_favorite': 1, 'access_count': 0,
      };

      final result = HymnNumberMapper.toMapper(row, group);

      expect(result.isFavorite, isTrue);
    });

    test('toMapper handles access_count = 0', () {
      final group = HymnGroupMapper.empty();
      final row = <String, Object?>{
        'id': 1, 'num': 1, 'code': '001', 'label': 'Hino 1',
        'type': 'NORMAL', 'hymns_group_id': 1,
        'last_accessed_at': null, 'is_favorite': 0, 'access_count': 0,
      };

      final result = HymnNumberMapper.toMapper(row, group);

      expect(result.accessCount, 0);
    });

    test('empty returns default values', () {
      final result = HymnNumberMapper.empty();

      expect(result.id, 0);
      expect(result.num, 0);
      expect(result.code, '');
      expect(result.label, '');
      expect(result.type, HymnNumberType.NORMAL);
      expect(result.lastAccessedAt, isNull);
      expect(result.isFavorite, isFalse);
      expect(result.accessCount, 0);
      expect(result.hymnsGroup, isA<HymnsGroup>());
    });
  });

  group('HymnContentMapper', () {
    test('toMapper maps all fields correctly', () {
      final hymnsNumber = HymnNumberMapper.empty();
      final row = <String, Object?>{
        'id': 1,
        'position': 1,
        'content': 'Hino content',
        'type_stanza': 'VERSE',
        'lang': 'PT',
        'hymns_number_id': 1,
      };

      final result = HymnContentMapper.toMapper(row, hymnsNumber);

      expect(result.id, 1);
      expect(result.position, 1);
      expect(result.content, 'Hino content');
      expect(result.typeStanza, 'VERSE');
      expect(result.lang, 'PT');
      expect(result.hymnsNumber, same(hymnsNumber));
    });

    test('toMapper handles type_stanza CHOIR', () {
      final hymnsNumber = HymnNumberMapper.empty();
      final row = <String, Object?>{
        'id': 2, 'position': 2, 'content': 'Choir content',
        'type_stanza': 'CHOIR', 'lang': 'PT', 'hymns_number_id': 1,
      };

      final result = HymnContentMapper.toMapper(row, hymnsNumber);

      expect(result.typeStanza, 'CHOIR');
    });

    test('empty returns default values', () {
      final result = HymnContentMapper.empty();

      expect(result.id, 0);
      expect(result.position, 0);
      expect(result.content, '');
      expect(result.typeStanza, '');
      expect(result.lang, '');
      expect(result.hymnsNumber, isA<HymnsNumber>());
    });
  });
}
