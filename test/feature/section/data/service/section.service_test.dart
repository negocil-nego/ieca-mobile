import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/_import.dart';

class MockSectionRepo extends Mock implements ISectionRepo {}

void main() {
  late MockSectionRepo mockRepo;
  late SectionService service;

  setUp(() {
    mockRepo = MockSectionRepo();
    service = SectionService(repo: mockRepo);
  });

  group('SectionService', () {
    test('findAll should return list of sections', () async {
      final sections = [
        Section(id: 1, code: 'PT', name: 'Português', isActive: 1),
        Section(id: 2, code: 'EN', name: 'English', isActive: 0),
      ];

      when(() => mockRepo.findAll()).thenAnswer(
        (_) async => Future.value(Result.ok(sections)),
      );

      final result = await service.findAll();

      result.when(
        ok: (value) {
          expect(value, hasLength(2));
          expect(value[0].code, 'PT');
          expect(value[1].code, 'EN');
        },
        error: (_) => fail('Expected ok result'),
      );
      verify(() => mockRepo.findAll()).called(1);
    });

    test('findDefault should return section', () async {
      final section = Section(id: 1, code: 'PT', name: 'Português', isActive: 1);

      when(() => mockRepo.findDefault()).thenAnswer(
        (_) async => Future.value(Result.ok(section)),
      );

      final result = await service.findDefault();

      result.when(
        ok: (value) {
          expect(value.id, 1);
          expect(value.code, 'PT');
        },
        error: (_) => fail('Expected ok result'),
      );
      verify(() => mockRepo.findDefault()).called(1);
    });

    test('findDefault should return error when no default found', () async {
      when(() => mockRepo.findDefault()).thenAnswer(
        (_) async => Future.value(Result.error(Exception('Not found'))),
      );

      final result = await service.findDefault();

      result.when(
        ok: (_) => fail('Expected error result'),
        error: (e) => expect(e.toString(), contains('Not found')),
      );
      verify(() => mockRepo.findDefault()).called(1);
    });

    test('updateDefault should delegate to repo', () async {
      final section = Section(id: 2, code: 'EN', name: 'English', isActive: 1);

      when(() => mockRepo.updateDefault(section)).thenAnswer(
        (_) async => Future.value(Result.ok(null)),
      );

      final result = await service.updateDefault(section);

      result.when(
        ok: (_) => expect(true, isTrue),
        error: (_) => fail('Expected ok result'),
      );
      verify(() => mockRepo.updateDefault(section)).called(1);
    });

    test('updateDefault should forward error from repo', () async {
      final section = Section(id: 99, code: 'XX', name: 'Unknown', isActive: 0);

      when(() => mockRepo.updateDefault(section)).thenAnswer(
        (_) async => Future.value(Result.error(Exception('Update failed'))),
      );

      final result = await service.updateDefault(section);

      result.when(
        ok: (_) => fail('Expected error result'),
        error: (e) => expect(e.toString(), contains('Update failed')),
      );
      verify(() => mockRepo.updateDefault(section)).called(1);
    });

    test('should use SectionSqliteRepo when no repo is provided', () {
      final serviceWithDefault = SectionService();
      expect(serviceWithDefault.repo, isA<SectionSqliteRepo>());
    });
  });
}
