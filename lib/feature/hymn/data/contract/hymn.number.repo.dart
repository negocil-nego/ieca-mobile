import 'package:mobile/_import.dart';

abstract class IHymnNumberRepo {
  Future<Result<List<HymnsNumber>>> findByHymnsGroup(HymnsGroup hymnsGroup);
  Future<Result<List<HymnsNumber>>> findAdditionalByGroup(HymnsGroup hymnsGroup);
  Future<Result<List<HymnsNumber>>> findFavouritesBySection(Section section);
  Future<Result<List<HymnsNumber>>> findFavouritesByGroup(HymnsGroup hymnsGroup);
  Future<Result<List<HymnsNumber>>> findLastAccessedBySection(Section section, {int limit = 10});
  Future<Result<List<HymnsNumber>>> findMostAccessedBySection(Section section, {int limit = 10});
  Future<Result<HymnsNumber?>> findNext(HymnsNumber current);
  Future<Result<HymnsNumber?>> findPrevious(HymnsNumber current);
  Future<Result<void>> updateLastAccessed(int id);
  Future<Result<void>> toggleFavorite(int id);
  Future<int> countBySection(Section section);
  Future<int> count();
}