import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/_import.dart';

class MockPsalmsRepo extends Mock implements IPsalmRepo {}

void main() {
  late PsalmService service;
  late MockPsalmsRepo mockRepo;

  setUp(() {
    mockRepo = MockPsalmsRepo();
    service = PsalmService(repo: mockRepo);
  });

  group('count', () {
    test('delegates to repo', () async {
      when(() => mockRepo.count()).thenAnswer((_) async => 5);

      final result = await service.count();

      expect(result, 5);
      verify(() => mockRepo.count()).called(1);
    });
  });

  group('countBySection', () {
    test('delegates to repo', () async {
      final section = SectionMapper.empty();
      when(() => mockRepo.countBySection(section)).thenAnswer((_) async => 3);

      final result = await service.countBySection(section);

      expect(result, 3);
      verify(() => mockRepo.countBySection(section)).called(1);
    });
  });

  group('findBySection', () {
    test('delegates to repo', () async {
      final section = SectionMapper.empty();
      final titles = [PsalmsMapper.empty()];
      when(() => mockRepo.findBySection(section))
          .thenAnswer((_) async => Result.ok(titles));

      final result = await service.findBySection(section);

      expect(result, isA<Ok<List<PsalmsTitle>>>());
      verify(() => mockRepo.findBySection(section)).called(1);
    });
  });

  group('findContentByPsalmsTitle', () {
    test('delegates to repo', () async {
      final psalm = PsalmsMapper.empty();
      final contents = [PsalmsContentMapper.empty()];
      when(() => mockRepo.findContentByPsalmsTitle(psalm))
          .thenAnswer((_) async => Result.ok(contents));

      final result = await service.findContentByPsalmsTitle(psalm);

      expect(result, isA<Ok<List<PsalmsContent>>>());
      verify(() => mockRepo.findContentByPsalmsTitle(psalm)).called(1);
    });
  });

  group('findContentFist', () {
    test('delegates to repo', () async {
      final psalm = PsalmsMapper.empty();
      final content = PsalmsContentMapper.empty();
      when(() => mockRepo.findContentFist(psalm))
          .thenAnswer((_) async => Result.ok(content));

      final result = await service.findContentFist(psalm);

      expect(result, isA<Ok<PsalmsContent>>());
      verify(() => mockRepo.findContentFist(psalm)).called(1);
    });
  });

  group('findLastAccessedBySection', () {
    test('delegates to repo with default limit', () async {
      final section = SectionMapper.empty();
      when(() => mockRepo.findLastAccessedBySection(section, limit: 10))
          .thenAnswer((_) async => Result.ok(<PsalmsTitle>[]));

      final result = await service.findLastAccessedBySection(section);

      expect(result, isA<Ok<List<PsalmsTitle>>>());
      verify(() => mockRepo.findLastAccessedBySection(section, limit: 10))
          .called(1);
    });

    test('delegates to repo with custom limit', () async {
      final section = SectionMapper.empty();
      when(() => mockRepo.findLastAccessedBySection(section, limit: 5))
          .thenAnswer((_) async => Result.ok(<PsalmsTitle>[]));

      final result =
          await service.findLastAccessedBySection(section, limit: 5);

      expect(result, isA<Ok<List<PsalmsTitle>>>());
      verify(() => mockRepo.findLastAccessedBySection(section, limit: 5))
          .called(1);
    });
  });

  group('findMostAccessedBySection', () {
    test('delegates to repo with default limit', () async {
      final section = SectionMapper.empty();
      when(() => mockRepo.findMostAccessedBySection(section, limit: 10))
          .thenAnswer((_) async => Result.ok(<PsalmsTitle>[]));

      final result = await service.findMostAccessedBySection(section);

      expect(result, isA<Ok<List<PsalmsTitle>>>());
      verify(() => mockRepo.findMostAccessedBySection(section, limit: 10))
          .called(1);
    });

    test('delegates to repo with custom limit', () async {
      final section = SectionMapper.empty();
      when(() => mockRepo.findMostAccessedBySection(section, limit: 3))
          .thenAnswer((_) async => Result.ok(<PsalmsTitle>[]));

      final result =
          await service.findMostAccessedBySection(section, limit: 3);

      expect(result, isA<Ok<List<PsalmsTitle>>>());
      verify(() => mockRepo.findMostAccessedBySection(section, limit: 3))
          .called(1);
    });
  });

  group('search', () {
    test('delegates to repo', () async {
      final section = SectionMapper.empty();
      when(() => mockRepo.search('busca', section))
          .thenAnswer((_) async => Result.ok(<PsalmsTitle>[]));

      final result = await service.search('busca', section);

      expect(result, isA<Ok<List<PsalmsTitle>>>());
      verify(() => mockRepo.search('busca', section)).called(1);
    });
  });

  group('findFavouritesBySection', () {
    test('delegates to repo', () async {
      final section = SectionMapper.empty();
      when(() => mockRepo.findFavouritesBySection(section))
          .thenAnswer((_) async => Result.ok(<PsalmsTitle>[]));

      final result = await service.findFavouritesBySection(section);

      expect(result, isA<Ok<List<PsalmsTitle>>>());
      verify(() => mockRepo.findFavouritesBySection(section)).called(1);
    });
  });

  group('findNext', () {
    test('delegates to repo', () async {
      final psalm = PsalmsMapper.empty();
      when(() => mockRepo.findNext(psalm))
          .thenAnswer((_) async => Result.ok(psalm));

      final result = await service.findNext(psalm);

      expect(result, isA<Ok<PsalmsTitle?>>());
      verify(() => mockRepo.findNext(psalm)).called(1);
    });
  });

  group('findPrevious', () {
    test('delegates to repo', () async {
      final psalm = PsalmsMapper.empty();
      when(() => mockRepo.findPrevious(psalm))
          .thenAnswer((_) async => Result.ok(psalm));

      final result = await service.findPrevious(psalm);

      expect(result, isA<Ok<PsalmsTitle?>>());
      verify(() => mockRepo.findPrevious(psalm)).called(1);
    });
  });

  group('updateLastAccessed', () {
    test('delegates to repo', () async {
      when(() => mockRepo.updateLastAccessed(1))
          .thenAnswer((_) async => Result.ok(null));

      final result = await service.updateLastAccessed(1);

      expect(result, isA<Ok<void>>());
      verify(() => mockRepo.updateLastAccessed(1)).called(1);
    });
  });

  group('toggleFavorite', () {
    test('delegates to repo', () async {
      when(() => mockRepo.toggleFavorite(1))
          .thenAnswer((_) async => Result.ok(null));

      final result = await service.toggleFavorite(1);

      expect(result, isA<Ok<void>>());
      verify(() => mockRepo.toggleFavorite(1)).called(1);
    });
  });
}
