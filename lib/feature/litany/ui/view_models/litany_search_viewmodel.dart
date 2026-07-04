import 'package:mobile/_import.dart';

class LitanySearchViewModel {
  final ILitanyService _service;

  LitanySearchViewModel({
    ILitanyService? service,
  }) : _service = service ?? LitanyService();

  Future<Result<List<LitanyTitle>>> search(String query, Section section) async {
    return await _service.search(query, section);
  }
}
