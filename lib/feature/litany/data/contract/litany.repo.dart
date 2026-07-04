import 'package:mobile/_import.dart';

abstract class ILitanyRepo {
  Future<Result<List<LitanyContent>>> findContentByLitanyTitle(LitanyTitle litanyTitle);
  Future<Result<LitanyContent>> findContentFist(LitanyTitle litanyTitle);
  Future<Result<List<LitanyTitle>>> findBySection(Section section);
  Future<Result<List<LitanyTitle>>> findFavouritesBySection(Section section);
  Future<Result<List<LitanyTitle>>> search(String search, Section section);
  Future<Result<void>> updateLastAccessed(int id);
  Future<Result<void>> toggleFavorite(int id);
  Future<int> countBySection(Section section);
  Future<int> count();
}
