import 'package:mobile/_import.dart';

class PsalmFavouritesViewModel {
  final IPsalmService _service;

  PsalmFavouritesViewModel({
    IPsalmService? service,
  }) : _service = service ?? PsalmService();

  Future<Result<List<PsalmsTitle>>> findFavouritesBySection(Section section) async {
    return await _service.findFavouritesBySection(section);
  }
}
