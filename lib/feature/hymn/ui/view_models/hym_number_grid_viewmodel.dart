import 'package:mobile/_import.dart';

class HymNumberGridViewModel {
  final IHymnNumberService _service;

  HymNumberGridViewModel({
    IHymnNumberService? service,
  }) : _service = service ?? HymnNumberService();

  Future<Result<List<HymnsNumber>>> findByHymnsGroup(HymnsGroup hymnsGroup) async {
    return await _service.findByHymnsGroup(hymnsGroup);
  }

  Future<Result<List<HymnsNumber>>> findAdditionalByGroup(HymnsGroup hymnsGroup) async {
    return await _service.findAdditionalByGroup(hymnsGroup);
  }

  Future<Result<List<HymnsNumber>>> findFavouritesByGroup(HymnsGroup hymnsGroup) async {
    return await _service.findFavouritesByGroup(hymnsGroup);
  }

  Future<Result<void>> updateLastAccessed(int id) async {
    return await _service.updateLastAccessed(id);
  }

  Future<Result<void>> toggleFavorite(int id) async {
    return await _service.toggleFavorite(id);
  }
}