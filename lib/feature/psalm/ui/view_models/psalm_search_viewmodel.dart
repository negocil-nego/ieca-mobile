import 'package:mobile/_import.dart';

class PsalmSearchViewModel {
  final IPsalmService _service;

  PsalmSearchViewModel({
    IPsalmService? service,
  }) : _service = service ?? PsalmService();

  Future<Result<List<PsalmsTitle>>> search(String query, Section section) async {
    return await _service.search(query, section);
  }
}
