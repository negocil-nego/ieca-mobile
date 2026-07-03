import 'package:mobile/_import.dart';

class InvocationFavouritesViewModel {
  final IInvocationService _service;

  InvocationFavouritesViewModel({
    IInvocationService? service,
  }) : _service = service ?? InvocationService();

  Future<Result<List<InvocationTitle>>> findFavouritesBySection(Section section) async {
    return await _service.findFavouritesBySection(section);
  }
}
