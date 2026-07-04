import 'package:mobile/_import.dart';

abstract class ILitanyService {
  ILitanyService({required this.repo});
  final ILitanyRepo repo;

  Future<Result<List<LitanyContent>>> findContentByLitanyTitle(LitanyTitle litanyTitle) => repo.findContentByLitanyTitle(litanyTitle);
  Future<Result<LitanyContent>> findContentFist(LitanyTitle litanyTitle) => repo.findContentFist(litanyTitle);
  Future<Result<List<LitanyTitle>>> findBySection(Section section) => repo.findBySection(section);
  Future<Result<List<LitanyTitle>>> findFavouritesBySection(Section section) => repo.findFavouritesBySection(section);
  Future<Result<List<LitanyTitle>>> search(String search, Section section) => repo.search(search, section);
  Future<Result<List<LitanyTitle>>> findLastAccessedBySection(Section section, {int limit = 10}) => repo.findLastAccessedBySection(section, limit: limit);
  Future<Result<List<LitanyTitle>>> findMostAccessedBySection(Section section, {int limit = 10}) => repo.findMostAccessedBySection(section, limit: limit);
  Future<Result<LitanyTitle?>> findNext(LitanyTitle current) => repo.findNext(current);
  Future<Result<LitanyTitle?>> findPrevious(LitanyTitle current) => repo.findPrevious(current);
  Future<Result<void>> updateLastAccessed(int id) => repo.updateLastAccessed(id);
  Future<Result<void>> toggleFavorite(int id) => repo.toggleFavorite(id);
  Future<int> countBySection(Section section) => repo.countBySection(section);
  Future<int> count() => repo.count();
}
