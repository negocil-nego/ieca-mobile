import 'package:mobile/_import.dart';

class InvocationSearchViewModel {
  final IInvocationService _service;

  InvocationSearchViewModel({
    IInvocationService? service,
  }) : _service = service ?? InvocationService();

  Future<Result<List<InvocationTitle>>> search(String query, Section section) async {
    return await _service.search(query, section);
  }
}
