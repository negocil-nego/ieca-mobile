import 'package:mobile/_import.dart';

abstract class IHymnNumberRepo {
  Future<Result<List<HymnsNumber>>> findByHymnsGroup(HymnsGroup hymnsGroup);
  Future<Result<List<HymnsNumber>>> findFavouritesBySection(Section section);
  Future<Result<List<HymnsNumber>>> findFavouritesByGroup(HymnsGroup hymnsGroup);
  Future<Result<void>> updateLastAccessed(int id);
  Future<Result<void>> toggleFavorite(int id);
  Future<int> countBySection(Section section);
  Future<int> count();
}