import 'package:mobile/_import.dart';

class LitanyFavouritesViewModel {
  final ILitanyService _service;

  LitanyFavouritesViewModel({
    ILitanyService? service,
  }) : _service = service ?? LitanyService();

  Future<Result<List<LitanyTitle>>> findFavouritesBySection(Section section) async {
    return await _service.findFavouritesBySection(section);
  }
}
