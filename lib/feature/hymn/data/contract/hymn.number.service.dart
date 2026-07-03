import 'package:mobile/_import.dart';

abstract class IHymnNumberService {
  IHymnNumberService({required this.repo});
  final IHymnNumberRepo repo;

  Future<int> count() => repo.count();
  Future<int> countBySection(Section section) => repo.countBySection(section);
  Future<Result<List<HymnsNumber>>> findByHymnsGroup(HymnsGroup hymnsGroup) => repo.findByHymnsGroup(hymnsGroup);
  Future<Result<List<HymnsNumber>>> findFavouritesBySection(Section section) => repo.findFavouritesBySection(section);
  Future<Result<void>> updateLastAccessed(int id) => repo.updateLastAccessed(id);
  Future<Result<void>> toggleFavorite(int id) => repo.toggleFavorite(id);
}
