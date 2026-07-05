import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/_import.dart';

class MockHymnNumberRepo extends Mock implements IHymnNumberRepo {}

void main() {
  late MockHymnNumberRepo mockRepo;
  late HymnNumberService service;
  late Section section;
  late HymnsGroup hymnsGroup;
  late HymnsNumber number;

  setUp(() {
    mockRepo = MockHymnNumberRepo();
    service = HymnNumberService(repo: mockRepo);
    section = SectionMapper.empty();
    hymnsGroup = HymnGroupMapper.empty();
    number = HymnNumberMapper.empty();
  });

  group('count', () {
    test('returns count from repo', () async {
      when(() => mockRepo.count()).thenAnswer((_) async => 5);

      final result = await service.count();

      expect(result, 5);
      verify(() => mockRepo.count()).called(1);
    });

    test('returns zero when repo returns zero', () async {
      when(() => mockRepo.count()).thenAnswer((_) async => 0);

      final result = await service.count();

      expect(result, 0);
    });
  });

  group('countBySection', () {
    test('returns count from repo', () async {
      when(() => mockRepo.countBySection(section)).thenAnswer((_) async => 3);

      final result = await service.countBySection(section);

      expect(result, 3);
      verify(() => mockRepo.countBySection(section)).called(1);
    });
  });

  group('findByHymnsGroup', () {
    test('returns list from repo', () async {
      when(() => mockRepo.findByHymnsGroup(hymnsGroup))
          .thenAnswer((_) async => Result.ok([number]));

      final result = await service.findByHymnsGroup(hymnsGroup);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      expect((result as Ok).value, [number]);
    });

    test('returns error from repo', () async {
      when(() => mockRepo.findByHymnsGroup(hymnsGroup))
          .thenAnswer((_) async => Result.error(Exception('error')));

      final result = await service.findByHymnsGroup(hymnsGroup);

      expect(result, isA<Error<List<HymnsNumber>>>());
    });

    test('returns empty list from repo', () async {
      when(() => mockRepo.findByHymnsGroup(hymnsGroup))
          .thenAnswer((_) async => Result.ok(<HymnsNumber>[]));

      final result = await service.findByHymnsGroup(hymnsGroup);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      expect((result as Ok).value, isEmpty);
    });
  });

  group('findFavouritesBySection', () {
    test('returns list from repo', () async {
      when(() => mockRepo.findFavouritesBySection(section))
          .thenAnswer((_) async => Result.ok([number]));

      final result = await service.findFavouritesBySection(section);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      verify(() => mockRepo.findFavouritesBySection(section)).called(1);
    });

    test('returns empty list from repo', () async {
      when(() => mockRepo.findFavouritesBySection(section))
          .thenAnswer((_) async => Result.ok(<HymnsNumber>[]));

      final result = await service.findFavouritesBySection(section);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      expect((result as Ok).value, isEmpty);
    });
  });

  group('findFavouritesByGroup', () {
    test('returns list from repo', () async {
      when(() => mockRepo.findFavouritesByGroup(hymnsGroup))
          .thenAnswer((_) async => Result.ok([number]));

      final result = await service.findFavouritesByGroup(hymnsGroup);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      verify(() => mockRepo.findFavouritesByGroup(hymnsGroup)).called(1);
    });

    test('returns empty list from repo', () async {
      when(() => mockRepo.findFavouritesByGroup(hymnsGroup))
          .thenAnswer((_) async => Result.ok(<HymnsNumber>[]));

      final result = await service.findFavouritesByGroup(hymnsGroup);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      expect((result as Ok).value, isEmpty);
    });
  });

  group('findLastAccessedBySection', () {
    test('returns list with default limit', () async {
      when(() => mockRepo.findLastAccessedBySection(section, limit: 10))
          .thenAnswer((_) async => Result.ok(<HymnsNumber>[]));

      final result = await service.findLastAccessedBySection(section);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      verify(() => mockRepo.findLastAccessedBySection(section, limit: 10)).called(1);
    });

    test('returns list with custom limit', () async {
      when(() => mockRepo.findLastAccessedBySection(section, limit: 5))
          .thenAnswer((_) async => Result.ok(<HymnsNumber>[]));

      final result = await service.findLastAccessedBySection(section, limit: 5);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      verify(() => mockRepo.findLastAccessedBySection(section, limit: 5)).called(1);
    });

    test('returns error from repo', () async {
      when(() => mockRepo.findLastAccessedBySection(section, limit: 10))
          .thenAnswer((_) async => Result.error(Exception('error')));

      final result = await service.findLastAccessedBySection(section);

      expect(result, isA<Error<List<HymnsNumber>>>());
    });
  });

  group('findMostAccessedBySection', () {
    test('returns list with default limit', () async {
      when(() => mockRepo.findMostAccessedBySection(section, limit: 10))
          .thenAnswer((_) async => Result.ok(<HymnsNumber>[]));

      final result = await service.findMostAccessedBySection(section);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      verify(() => mockRepo.findMostAccessedBySection(section, limit: 10)).called(1);
    });

    test('returns list with custom limit', () async {
      when(() => mockRepo.findMostAccessedBySection(section, limit: 3))
          .thenAnswer((_) async => Result.ok(<HymnsNumber>[]));

      final result = await service.findMostAccessedBySection(section, limit: 3);

      expect(result, isA<Ok<List<HymnsNumber>>>());
      verify(() => mockRepo.findMostAccessedBySection(section, limit: 3)).called(1);
    });
  });

  group('findNext', () {
    test('returns next number', () async {
      final next = HymnsNumber(id: 2, num: 2, code: '002', label: 'Next', hymnsGroup: hymnsGroup);
      when(() => mockRepo.findNext(number))
          .thenAnswer((_) async => Result.ok(next));

      final result = await service.findNext(number);

      expect(result, isA<Ok<HymnsNumber?>>());
      expect((result as Ok).value, next);
    });

    test('returns null when no next', () async {
      when(() => mockRepo.findNext(number))
          .thenAnswer((_) async => Result.ok(null));

      final result = await service.findNext(number);

      expect(result, isA<Ok<HymnsNumber?>>());
      expect((result as Ok).value, isNull);
    });

    test('returns error from repo', () async {
      when(() => mockRepo.findNext(number))
          .thenAnswer((_) async => Result.error(Exception('error')));

      final result = await service.findNext(number);

      expect(result, isA<Error<HymnsNumber?>>());
    });
  });

  group('findPrevious', () {
    test('returns previous number', () async {
      final prev = HymnsNumber(id: 1, num: 1, code: '001', label: 'Prev', hymnsGroup: hymnsGroup);
      when(() => mockRepo.findPrevious(number))
          .thenAnswer((_) async => Result.ok(prev));

      final result = await service.findPrevious(number);

      expect(result, isA<Ok<HymnsNumber?>>());
      expect((result as Ok).value, prev);
    });

    test('returns null when no previous', () async {
      when(() => mockRepo.findPrevious(number))
          .thenAnswer((_) async => Result.ok(null));

      final result = await service.findPrevious(number);

      expect(result, isA<Ok<HymnsNumber?>>());
      expect((result as Ok).value, isNull);
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

    test('returns error from repo', () async {
      when(() => mockRepo.updateLastAccessed(999))
          .thenAnswer((_) async => Result.error(Exception('not found')));

      final result = await service.updateLastAccessed(999);

      expect(result, isA<Error<void>>());
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

    test('returns error from repo', () async {
      when(() => mockRepo.toggleFavorite(999))
          .thenAnswer((_) async => Result.error(Exception('not found')));

      final result = await service.toggleFavorite(999);

      expect(result, isA<Error<void>>());
    });
  });
}
