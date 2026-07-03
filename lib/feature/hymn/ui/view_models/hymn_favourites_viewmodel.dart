import 'package:mobile/_import.dart';

class HymnFavouritesViewModel {
  final IHymnNumberService _service;

  HymnFavouritesViewModel({
    IHymnNumberService? service,
  }) : _service = service ?? HymnNumberService();

  Future<Result<List<HymnsNumber>>> findFavouritesBySection(Section section) async {
    return await _service.findFavouritesBySection(section);
  }
}
