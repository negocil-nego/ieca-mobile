
import 'package:mobile/_import.dart';

final class PsalmsMapper {
  static PsalmsTitle empty() {
    return PsalmsTitle(id: 0, name: "", position: 0, section: SectionMapper.empty(),);
  }

  static PsalmsTitle toMapper(Map<String, Object?> row, Section section) {
    final lastAccessedRaw = row['last_accessed_at'] as int?;
    return PsalmsTitle(
      id: row['id'] as int,
      name: row['name'] as String,
      position: row['position'] as int,
      section: section,
      lastAccessedAt: lastAccessedRaw != null ? DateTime.fromMillisecondsSinceEpoch(lastAccessedRaw) : null,
      isFavorite: (row['is_favorite'] as int?) == 1,
      accessCount: (row['access_count'] as int?) ?? 0,
    );
  }
}

final class PsalmsContentMapper {
  static PsalmsContent empty() {
    return PsalmsContent(id: 0, person: "", content: "", position: 0, psalm: PsalmsMapper.empty());
  }

  static PsalmsContent toMapper(Map<String, Object?> row, PsalmsTitle psalm) {
    return PsalmsContent(
      id: row['id'] as int,
      person: row['person'] as String,
      content: row['content'] as String,
      position: row['position'] as int,
      psalm: psalm,
    );
  }
}