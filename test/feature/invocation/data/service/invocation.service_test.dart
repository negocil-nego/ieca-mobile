import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/_import.dart';

class MockInvocationRepo extends Mock implements IInvocationRepo {}

void main() {
  late MockInvocationRepo mockRepo;
  late IInvocationService service;
  late Section section;
  late InvocationTitle invocation;

  setUp(() {
    mockRepo = MockInvocationRepo();
    service = InvocationService(repo: mockRepo);
    section = SectionMapper.empty();
    invocation = InvocationMapper.empty();
  });

  group('count', () {
    test('should delegate to repo and return count', () async {
      when(() => mockRepo.count()).thenAnswer((_) async => 5);

      expect(await service.count(), 5);

      verify(() => mockRepo.count()).called(1);
    });

    test('should return 0 when repo returns 0', () async {
      when(() => mockRepo.count()).thenAnswer((_) async => 0);

      expect(await service.count(), 0);

      verify(() => mockRepo.count()).called(1);
    });
  });

  group('countBySection', () {
    test('should delegate to repo with correct section', () async {
      when(() => mockRepo.countBySection(section)).thenAnswer((_) async => 3);

      expect(await service.countBySection(section), 3);

      verify(() => mockRepo.countBySection(section)).called(1);
    });

    test('should return 0 when no items in section', () async {
      when(() => mockRepo.countBySection(section)).thenAnswer((_) async => 0);

      expect(await service.countBySection(section), 0);

      verify(() => mockRepo.countBySection(section)).called(1);
    });
  });

  group('findBySection', () {
    test('should delegate to repo and return list', () async {
      final list = [invocation];
      when(() => mockRepo.findBySection(section)).thenAnswer((_) async => Result.ok(list));

      final result = await service.findBySection(section);

      result.when(
        ok: (value) => expect(value, same(list)),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.findBySection(section)).called(1);
    });

    test('should return error when repo fails', () async {
      when(() => mockRepo.findBySection(section)).thenAnswer((_) async => Result.error(Exception('db error')));

      final result = await service.findBySection(section);

      result.when(
        ok: (_) => fail('should be error'),
        error: (e) => expect(e.toString(), contains('db error')),
      );
      verify(() => mockRepo.findBySection(section)).called(1);
    });

    test('should return empty list', () async {
      when(() => mockRepo.findBySection(section)).thenAnswer((_) async => Result.ok(<InvocationTitle>[]));

      final result = await service.findBySection(section);

      result.when(
        ok: (value) => expect(value, isEmpty),
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('findContentByInvocation', () {
    test('should delegate to repo', () async {
      final contentList = [InvocationContentMapper.empty()];
      when(() => mockRepo.findContentByInvocation(invocation)).thenAnswer((_) async => Result.ok(contentList));

      final result = await service.findContentByInvocation(invocation);

      result.when(
        ok: (value) => expect(value, same(contentList)),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.findContentByInvocation(invocation)).called(1);
    });

    test('should return error when repo fails', () async {
      when(() => mockRepo.findContentByInvocation(invocation)).thenAnswer((_) async => Result.error(Exception('no content')));

      final result = await service.findContentByInvocation(invocation);

      result.when(
        ok: (_) => fail('should be error'),
        error: (e) => expect(e.toString(), contains('no content')),
      );
    });
  });

  group('findContentFist', () {
    test('should delegate to repo', () async {
      final content = InvocationContentMapper.empty();
      when(() => mockRepo.findContentFist(invocation)).thenAnswer((_) async => Result.ok(content));

      final result = await service.findContentFist(invocation);

      result.when(
        ok: (value) => expect(value, same(content)),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.findContentFist(invocation)).called(1);
    });
  });

  group('findLastAccessedBySection', () {
    test('should delegate with default limit', () async {
      when(() => mockRepo.findLastAccessedBySection(section)).thenAnswer((_) async => Result.ok([invocation]));

      final result = await service.findLastAccessedBySection(section);

      result.when(
        ok: (value) => expect(value, [invocation]),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.findLastAccessedBySection(section)).called(1);
    });

    test('should delegate with custom limit', () async {
      when(() => mockRepo.findLastAccessedBySection(section, limit: 5)).thenAnswer((_) async => Result.ok([invocation]));

      final result = await service.findLastAccessedBySection(section, limit: 5);

      result.when(
        ok: (value) => expect(value, [invocation]),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.findLastAccessedBySection(section, limit: 5)).called(1);
    });

    test('should return empty list', () async {
      when(() => mockRepo.findLastAccessedBySection(section)).thenAnswer((_) async => Result.ok(<InvocationTitle>[]));

      final result = await service.findLastAccessedBySection(section);

      result.when(
        ok: (value) => expect(value, isEmpty),
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('findMostAccessedBySection', () {
    test('should delegate with default limit', () async {
      when(() => mockRepo.findMostAccessedBySection(section)).thenAnswer((_) async => Result.ok([invocation]));

      final result = await service.findMostAccessedBySection(section);

      result.when(
        ok: (value) => expect(value, [invocation]),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.findMostAccessedBySection(section)).called(1);
    });

    test('should delegate with custom limit', () async {
      when(() => mockRepo.findMostAccessedBySection(section, limit: 5)).thenAnswer((_) async => Result.ok([invocation]));

      final result = await service.findMostAccessedBySection(section, limit: 5);

      result.when(
        ok: (value) => expect(value, [invocation]),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.findMostAccessedBySection(section, limit: 5)).called(1);
    });
  });

  group('search', () {
    test('should delegate to repo with correct params', () async {
      const query = 'test';
      when(() => mockRepo.search(query, section)).thenAnswer((_) async => Result.ok([invocation]));

      final result = await service.search(query, section);

      result.when(
        ok: (value) => expect(value, [invocation]),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.search(query, section)).called(1);
    });

    test('should return error when repo fails', () async {
      const query = 'test';
      when(() => mockRepo.search(query, section)).thenAnswer((_) async => Result.error(Exception('search failed')));

      final result = await service.search(query, section);

      result.when(
        ok: (_) => fail('should be error'),
        error: (e) => expect(e.toString(), contains('search failed')),
      );
    });
  });

  group('findFavouritesBySection', () {
    test('should delegate to repo', () async {
      when(() => mockRepo.findFavouritesBySection(section)).thenAnswer((_) async => Result.ok([invocation]));

      final result = await service.findFavouritesBySection(section);

      result.when(
        ok: (value) => expect(value, [invocation]),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.findFavouritesBySection(section)).called(1);
    });

    test('should return empty list', () async {
      when(() => mockRepo.findFavouritesBySection(section)).thenAnswer((_) async => Result.ok(<InvocationTitle>[]));

      final result = await service.findFavouritesBySection(section);

      result.when(
        ok: (value) => expect(value, isEmpty),
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('findNext', () {
    test('should return next invocation', () async {
      when(() => mockRepo.findNext(invocation)).thenAnswer((_) async => Result.ok(invocation));

      final result = await service.findNext(invocation);

      result.when(
        ok: (value) => expect(value, same(invocation)),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.findNext(invocation)).called(1);
    });

    test('should return null when no next', () async {
      when(() => mockRepo.findNext(invocation)).thenAnswer((_) async => Result.ok(null));

      final result = await service.findNext(invocation);

      result.when(
        ok: (value) => expect(value, isNull),
        error: (_) => fail('should be ok'),
      );
    });

    test('should return error when repo fails', () async {
      when(() => mockRepo.findNext(invocation)).thenAnswer((_) async => Result.error(Exception('no next')));

      final result = await service.findNext(invocation);

      result.when(
        ok: (_) => fail('should be error'),
        error: (e) => expect(e.toString(), contains('no next')),
      );
    });
  });

  group('findPrevious', () {
    test('should return previous invocation', () async {
      when(() => mockRepo.findPrevious(invocation)).thenAnswer((_) async => Result.ok(invocation));

      final result = await service.findPrevious(invocation);

      result.when(
        ok: (value) => expect(value, same(invocation)),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.findPrevious(invocation)).called(1);
    });

    test('should return null when no previous', () async {
      when(() => mockRepo.findPrevious(invocation)).thenAnswer((_) async => Result.ok(null));

      final result = await service.findPrevious(invocation);

      result.when(
        ok: (value) => expect(value, isNull),
        error: (_) => fail('should be ok'),
      );
    });
  });

  group('updateLastAccessed', () {
    test('should delegate to repo with correct id', () async {
      when(() => mockRepo.updateLastAccessed(1)).thenAnswer((_) async => Result.ok(null));

      final result = await service.updateLastAccessed(1);

      result.when(
        ok: (_) => expect(true, isTrue),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.updateLastAccessed(1)).called(1);
    });

    test('should return error when repo fails', () async {
      when(() => mockRepo.updateLastAccessed(1)).thenAnswer((_) async => Result.error(Exception('update failed')));

      final result = await service.updateLastAccessed(1);

      result.when(
        ok: (_) => fail('should be error'),
        error: (e) => expect(e.toString(), contains('update failed')),
      );
    });
  });

  group('toggleFavorite', () {
    test('should delegate to repo with correct id', () async {
      when(() => mockRepo.toggleFavorite(1)).thenAnswer((_) async => Result.ok(null));

      final result = await service.toggleFavorite(1);

      result.when(
        ok: (_) => expect(true, isTrue),
        error: (_) => fail('should be ok'),
      );
      verify(() => mockRepo.toggleFavorite(1)).called(1);
    });

    test('should return error when repo fails', () async {
      when(() => mockRepo.toggleFavorite(1)).thenAnswer((_) async => Result.error(Exception('toggle failed')));

      final result = await service.toggleFavorite(1);

      result.when(
        ok: (_) => fail('should be error'),
        error: (e) => expect(e.toString(), contains('toggle failed')),
      );
    });
  });
}
