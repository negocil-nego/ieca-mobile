import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/_import.dart';

class MockILitanyRepo extends Mock implements ILitanyRepo {}

void main() {
  late MockILitanyRepo repo;
  late LitanyService service;
  late Section section;
  late LitanyTitle litanyTitle;

  setUp(() {
    repo = MockILitanyRepo();
    service = LitanyService(repo: repo);
    section = SectionMapper.empty();
    litanyTitle = LitanyMapper.empty();
  });

  group('count', () {
    test('delegates to repo', () async {
      when(() => repo.count()).thenAnswer((_) async => 5);

      final result = await service.count();

      expect(result, 5);
      verify(() => repo.count()).called(1);
    });
  });

  group('countBySection', () {
    test('delegates to repo', () async {
      when(() => repo.countBySection(section)).thenAnswer((_) async => 3);

      final result = await service.countBySection(section);

      expect(result, 3);
      verify(() => repo.countBySection(section)).called(1);
    });
  });

  group('findBySection', () {
    test('delegates to repo', () async {
      final list = [litanyTitle];
      when(() => repo.findBySection(section))
          .thenAnswer((_) async => Result.ok(list));

      final result = await service.findBySection(section);

      result.when(
        ok: (v) => expect(v, list),
        error: (_) => fail('Expected Ok'),
      );
      verify(() => repo.findBySection(section)).called(1);
    });
  });

  group('findContentByLitanyTitle', () {
    test('delegates to repo', () async {
      final content = LitanyContentMapper.empty();
      when(() => repo.findContentByLitanyTitle(litanyTitle))
          .thenAnswer((_) async => Result.ok([content]));

      final result = await service.findContentByLitanyTitle(litanyTitle);

      result.when(
        ok: (v) => expect(v, [content]),
        error: (_) => fail('Expected Ok'),
      );
      verify(() => repo.findContentByLitanyTitle(litanyTitle)).called(1);
    });
  });

  group('findContentFist', () {
    test('delegates to repo', () async {
      final content = LitanyContentMapper.empty();
      when(() => repo.findContentFist(litanyTitle))
          .thenAnswer((_) async => Result.ok(content));

      final result = await service.findContentFist(litanyTitle);

      result.when(
        ok: (v) => expect(v, content),
        error: (_) => fail('Expected Ok'),
      );
      verify(() => repo.findContentFist(litanyTitle)).called(1);
    });
  });

  group('findLastAccessedBySection', () {
    test('delegates with default limit', () async {
      when(() => repo.findLastAccessedBySection(section, limit: 10))
          .thenAnswer((_) async => Result.ok([]));

      await service.findLastAccessedBySection(section);

      verify(() => repo.findLastAccessedBySection(section, limit: 10))
          .called(1);
    });

    test('delegates with custom limit', () async {
      when(() => repo.findLastAccessedBySection(section, limit: 5))
          .thenAnswer((_) async => Result.ok([]));

      await service.findLastAccessedBySection(section, limit: 5);

      verify(() => repo.findLastAccessedBySection(section, limit: 5))
          .called(1);
    });
  });

  group('findMostAccessedBySection', () {
    test('delegates with default limit', () async {
      when(() => repo.findMostAccessedBySection(section, limit: 10))
          .thenAnswer((_) async => Result.ok([]));

      await service.findMostAccessedBySection(section);

      verify(() => repo.findMostAccessedBySection(section, limit: 10))
          .called(1);
    });

    test('delegates with custom limit', () async {
      when(() => repo.findMostAccessedBySection(section, limit: 3))
          .thenAnswer((_) async => Result.ok([]));

      await service.findMostAccessedBySection(section, limit: 3);

      verify(() => repo.findMostAccessedBySection(section, limit: 3))
          .called(1);
    });
  });

  group('search', () {
    test('delegates to repo', () async {
      when(() => repo.search('query', section))
          .thenAnswer((_) async => Result.ok([]));

      await service.search('query', section);

      verify(() => repo.search('query', section)).called(1);
    });
  });

  group('findFavouritesBySection', () {
    test('delegates to repo', () async {
      when(() => repo.findFavouritesBySection(section))
          .thenAnswer((_) async => Result.ok([]));

      await service.findFavouritesBySection(section);

      verify(() => repo.findFavouritesBySection(section)).called(1);
    });
  });

  group('findNext', () {
    test('delegates to repo', () async {
      when(() => repo.findNext(litanyTitle))
          .thenAnswer((_) async => Result.ok(null));

      await service.findNext(litanyTitle);

      verify(() => repo.findNext(litanyTitle)).called(1);
    });
  });

  group('findPrevious', () {
    test('delegates to repo', () async {
      when(() => repo.findPrevious(litanyTitle))
          .thenAnswer((_) async => Result.ok(null));

      await service.findPrevious(litanyTitle);

      verify(() => repo.findPrevious(litanyTitle)).called(1);
    });
  });

  group('updateLastAccessed', () {
    test('delegates to repo', () async {
      when(() => repo.updateLastAccessed(1))
          .thenAnswer((_) async => Result.ok(null));

      await service.updateLastAccessed(1);

      verify(() => repo.updateLastAccessed(1)).called(1);
    });
  });

  group('toggleFavorite', () {
    test('delegates to repo', () async {
      when(() => repo.toggleFavorite(2))
          .thenAnswer((_) async => Result.ok(null));

      await service.toggleFavorite(2);

      verify(() => repo.toggleFavorite(2)).called(1);
    });
  });
}
