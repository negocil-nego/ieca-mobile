import 'package:mobile/_import.dart';

class LitanyContentBottomSheetViewModel {
  final ILitanyService _service;

  LitanyContentBottomSheetViewModel({
    ILitanyService? service,
  }) : _service = service ?? LitanyService();

  Future<Result<List<LitanyContent>>> findContentByLitanyTitle(LitanyTitle litanyTitle) async {
    return await _service.findContentByLitanyTitle(litanyTitle);
  }

  Future<Result<LitanyContent>> findContentFist(LitanyTitle litanyTitle) async {
    return await _service.findContentFist(litanyTitle);
  }

  Future<Result<void>> updateLastAccessed(int id) async {
    return await _service.updateLastAccessed(id);
  }

  Future<Result<LitanyTitle?>> findNext(LitanyTitle current) async {
    return await _service.findNext(current);
  }

  Future<Result<LitanyTitle?>> findPrevious(LitanyTitle current) async {
    return await _service.findPrevious(current);
  }

  Future<Result<void>> toggleFavorite(int id) async {
    return await _service.toggleFavorite(id);
  }
}
