import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/_import.dart';

class MockHymnContentRepo extends Mock implements IHymnContentRepo {}

void main() {
  late MockHymnContentRepo mockRepo;
  late HymnContentService service;
  late Section section;
  late HymnsNumber number;

  setUp(() {
    mockRepo = MockHymnContentRepo();
    service = HymnContentService(repo: mockRepo);
    section = SectionMapper.empty();
    number = HymnNumberMapper.empty();
  });

  group('findByHymnNumber', () {
    test('returns content from repo', () async {
      final content = HymnsContent(
        id: 1, position: 1, content: 'test', lang: 'PT',
        hymnsNumber: number,
      );
      when(() => mockRepo.findByHymnsNumber(number))
          .thenAnswer((_) async => Result.ok([content]));

      final result = await service.findByHymnNumber(number);

      expect(result, isA<Ok<List<HymnsContent>>>());
      expect((result as Ok).value, [content]);
      verify(() => mockRepo.findByHymnsNumber(number)).called(1);
    });

    test('returns empty list from repo', () async {
      when(() => mockRepo.findByHymnsNumber(number))
          .thenAnswer((_) async => Result.ok(<HymnsContent>[]));

      final result = await service.findByHymnNumber(number);

      expect(result, isA<Ok<List<HymnsContent>>>());
      expect((result as Ok).value, isEmpty);
    });

    test('returns error from repo', () async {
      when(() => mockRepo.findByHymnsNumber(number))
          .thenAnswer((_) async => Result.error(Exception('error')));

      final result = await service.findByHymnNumber(number);

      expect(result, isA<Error<List<HymnsContent>>>());
    });
  });

  group('search', () {
    test('returns search results from repo', () async {
      final content = HymnsContent(
        id: 1, position: 1, content: 'result', lang: 'PT',
        hymnsNumber: number,
      );
      when(() => mockRepo.search('test', section))
          .thenAnswer((_) async => Result.ok([content]));

      final result = await service.search('test', section);

      expect(result, isA<Ok<List<HymnsContent>>>());
      expect((result as Ok).value, [content]);
      verify(() => mockRepo.search('test', section)).called(1);
    });

    test('returns empty list from repo', () async {
      when(() => mockRepo.search('nonexistent', section))
          .thenAnswer((_) async => Result.ok(<HymnsContent>[]));

      final result = await service.search('nonexistent', section);

      expect(result, isA<Ok<List<HymnsContent>>>());
      expect((result as Ok).value, isEmpty);
    });

    test('returns error from repo', () async {
      when(() => mockRepo.search('error', section))
          .thenAnswer((_) async => Result.error(Exception('error')));

      final result = await service.search('error', section);

      expect(result, isA<Error<List<HymnsContent>>>());
    });
  });
}
