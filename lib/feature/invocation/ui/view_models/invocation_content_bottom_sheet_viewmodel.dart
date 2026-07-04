
import 'package:mobile/_import.dart';

class InvocationContentBottomSheetViewModel {
  final IInvocationService _service;

  InvocationContentBottomSheetViewModel({
    IInvocationService? service,
  }) : _service = service ?? InvocationService();

  Future<Result<List<InvocationContent>>> findContentByInvocation(InvocationTitle invocation) async {
    return await _service.findContentByInvocation(invocation);
  }

  Future<Result<InvocationContent>> findContentFist(InvocationTitle invocation) async {
    return await _service.findContentFist(invocation);
  }

  Future<Result<void>> updateLastAccessed(int id) async {
    return await _service.updateLastAccessed(id);
  }

  Future<Result<InvocationTitle?>> findNext(InvocationTitle current) async {
    return await _service.findNext(current);
  }

  Future<Result<InvocationTitle?>> findPrevious(InvocationTitle current) async {
    return await _service.findPrevious(current);
  }

  Future<Result<void>> toggleFavorite(int id) async {
    return await _service.toggleFavorite(id);
  }
}