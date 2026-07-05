import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/_import.dart';

class MockHymnGroupRepo extends Mock implements IHymnGroupRepo {}

void main() {
  late MockHymnGroupRepo mockRepo;
  late HymnGroupService service;
  late Section section;
  late HymnsGroup hymnsGroup;

  setUp(() {
    mockRepo = MockHymnGroupRepo();
    service = HymnGroupService(repo: mockRepo);
    section = SectionMapper.empty();
    hymnsGroup = HymnGroupMapper.empty();
  });

  group('findBySection', () {
    test('returns groups from repo', () async {
      when(() => mockRepo.findBySection(section))
          .thenAnswer((_) async => Result.ok([hymnsGroup]));

      final result = await service.findBySection(section);

      expect(result, isA<Ok<List<HymnsGroup>>>());
      expect((result as Ok).value, [hymnsGroup]);
      verify(() => mockRepo.findBySection(section)).called(1);
    });

    test('returns empty list from repo', () async {
      when(() => mockRepo.findBySection(section))
          .thenAnswer((_) async => Result.ok(<HymnsGroup>[]));

      final result = await service.findBySection(section);

      expect(result, isA<Ok<List<HymnsGroup>>>());
      expect((result as Ok).value, isEmpty);
    });

    test('returns error from repo', () async {
      when(() => mockRepo.findBySection(section))
          .thenAnswer((_) async => Result.error(Exception('error')));

      final result = await service.findBySection(section);

      expect(result, isA<Error<List<HymnsGroup>>>());
    });
  });

  group('findFavouriteBySection', () {
    test('returns favourite groups from repo', () async {
      when(() => mockRepo.findFavouriteBySection(section))
          .thenAnswer((_) async => Result.ok([hymnsGroup]));

      final result = await service.findFavouriteBySection(section);

      expect(result, isA<Ok<List<HymnsGroup>>>());
      expect((result as Ok).value, [hymnsGroup]);
      verify(() => mockRepo.findFavouriteBySection(section)).called(1);
    });

    test('returns empty list from repo', () async {
      when(() => mockRepo.findFavouriteBySection(section))
          .thenAnswer((_) async => Result.ok(<HymnsGroup>[]));

      final result = await service.findFavouriteBySection(section);

      expect(result, isA<Ok<List<HymnsGroup>>>());
      expect((result as Ok).value, isEmpty);
    });

    test('returns error from repo', () async {
      when(() => mockRepo.findFavouriteBySection(section))
          .thenAnswer((_) async => Result.error(Exception('error')));

      final result = await service.findFavouriteBySection(section);

      expect(result, isA<Error<List<HymnsGroup>>>());
    });
  });
}
