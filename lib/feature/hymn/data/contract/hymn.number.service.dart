import 'package:mobile/_import.dart';

abstract class IHymnNumberService {
  IHymnNumberService({required this.repo});
  final IHymnNumberRepo repo;

  Future<int> count() => repo.count();
  Future<int> countBySection(Section section) => repo.countBySection(section);
  Future<Result<List<HymnsNumber>>> findByHymnsGroup(HymnsGroup hymnsGroup) => repo.findByHymnsGroup(hymnsGroup);
  Future<Result<List<HymnsNumber>>> findFavouritesBySection(Section section) => repo.findFavouritesBySection(section);
  Future<Result<List<HymnsNumber>>> findFavouritesByGroup(HymnsGroup hymnsGroup) => repo.findFavouritesByGroup(hymnsGroup);
  Future<Result<List<HymnsNumber>>> findLastAccessedBySection(Section section, {int limit = 10}) => repo.findLastAccessedBySection(section, limit: limit);
  Future<Result<List<HymnsNumber>>> findMostAccessedBySection(Section section, {int limit = 10}) => repo.findMostAccessedBySection(section, limit: limit);
  Future<Result<HymnsNumber?>> findNext(HymnsNumber current) => repo.findNext(current);
  Future<Result<HymnsNumber?>> findPrevious(HymnsNumber current) => repo.findPrevious(current);
  Future<Result<void>> updateLastAccessed(int id) => repo.updateLastAccessed(id);
  Future<Result<void>> toggleFavorite(int id) => repo.toggleFavorite(id);
}
