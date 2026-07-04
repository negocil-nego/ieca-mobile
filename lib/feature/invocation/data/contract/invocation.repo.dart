import 'package:mobile/_import.dart';

abstract class IInvocationRepo {
  Future<Result<List<InvocationContent>>> findContentByInvocation(InvocationTitle invocation);
  Future<Result<InvocationContent>> findContentFist(InvocationTitle invocation);
  Future<Result<List<InvocationTitle>>> findBySection(Section section);
  Future<Result<List<InvocationTitle>>> findFavouritesBySection(Section section);
  Future<Result<List<InvocationTitle>>> search(String search, Section section);
  Future<Result<List<InvocationTitle>>> findLastAccessedBySection(Section section, {int limit = 10});
  Future<Result<List<InvocationTitle>>> findMostAccessedBySection(Section section, {int limit = 10});
  Future<Result<InvocationTitle?>> findNext(InvocationTitle current);
  Future<Result<InvocationTitle?>> findPrevious(InvocationTitle current);
  Future<Result<void>> updateLastAccessed(int id);
  Future<Result<void>> toggleFavorite(int id);

  Future<int> countBySection(Section section);
  Future<int> count();
}
