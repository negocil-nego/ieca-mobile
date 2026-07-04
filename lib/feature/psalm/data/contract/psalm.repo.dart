import 'package:mobile/_import.dart';
abstract class IPsalmRepo {
  Future<Result<List<PsalmsContent>>> findContentByPsalmsTitle(PsalmsTitle psalmsTitle);
  Future<Result<PsalmsContent>> findContentFist(PsalmsTitle psalmsTitle);
  Future<Result<List<PsalmsTitle>>> findBySection(Section section);
  Future<Result<List<PsalmsTitle>>> findFavouritesBySection(Section section);
  Future<Result<List<PsalmsTitle>>> search(String search, Section section);
  Future<Result<List<PsalmsTitle>>> findLastAccessedBySection(Section section, {int limit = 10});
  Future<Result<List<PsalmsTitle>>> findMostAccessedBySection(Section section, {int limit = 10});
  Future<Result<PsalmsTitle?>> findNext(PsalmsTitle current);
  Future<Result<PsalmsTitle?>> findPrevious(PsalmsTitle current);
  Future<Result<void>> updateLastAccessed(int id);
  Future<Result<void>> toggleFavorite(int id);
  Future<int> countBySection(Section section);
  Future<int> count();
}
