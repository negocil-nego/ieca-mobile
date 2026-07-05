import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/_import.dart';

class MockSectionRepo extends Mock implements ISectionRepo {}

void main() {
  late MockSectionRepo mockRepo;
  late SectionProvider provider;

  setUp(() {
    mockRepo = MockSectionRepo();
  });

  group('SectionProvider', () {
    test('should cache section from findDefault on initialization', () async {
      const expectedSection = Section(
        id: 1,
        code: 'PT',
        name: 'Português',
        isActive: 1,
      );

      when(() => mockRepo.findDefault()).thenAnswer(
        (_) async => Future.value(Result.ok(expectedSection)),
      );

      provider = SectionProvider(repo: mockRepo);

      await Future.microtask(() {});

      expect(provider.section.id, expectedSection.id);
      expect(provider.section.code, expectedSection.code);
    });

    test('should return SectionMapper.empty() when no section cached', () {
      when(() => mockRepo.findDefault()).thenAnswer(
        (_) async => Future.value(
          Result.error(Exception('No default section')),
        ),
      );

      provider = SectionProvider(repo: mockRepo);

      expect(provider.section.id, 1);
      expect(provider.section.code, 'PT');
      expect(provider.section.name, 'Português');
      expect(provider.section.isActive, 1);
    });

    test('should update section and notify listeners on updateDefault', () async {
      const initialSection = Section(
        id: 1,
        code: 'PT',
        name: 'Português',
        isActive: 1,
      );
      const updatedSection = Section(
        id: 2,
        code: 'EN',
        name: 'English',
        isActive: 1,
      );

      when(() => mockRepo.findDefault()).thenAnswer(
        (_) async => Future.value(Result.ok(initialSection)),
      );
      when(() => mockRepo.updateDefault(updatedSection)).thenAnswer(
        (_) async => Future.value(Result.ok(null)),
      );

      provider = SectionProvider(repo: mockRepo);
      await Future.microtask(() {});

      expect(provider.section.id, 1);

      var listenerCallCount = 0;
      provider.addListener(() {
        listenerCallCount++;
      });

      await provider.updateDefault(updatedSection);

      expect(provider.section.id, 2);
      expect(provider.section.code, 'EN');
      expect(listenerCallCount, 1);
    });

    test('should reuse cached section when findDefault returns same id', () async {
      const section = Section(
        id: 1,
        code: 'PT',
        name: 'Português',
        isActive: 1,
      );

      when(() => mockRepo.findDefault()).thenAnswer(
        (_) async => Future.value(Result.ok(section)),
      );

      provider = SectionProvider(repo: mockRepo);
      await Future.microtask(() {});

      var listenerCallCount = 0;
      provider.addListener(() {
        listenerCallCount++;
      });

      await provider.findDefault();

      expect(listenerCallCount, 0);
      expect(provider.section.id, 1);
    });
  });
}
