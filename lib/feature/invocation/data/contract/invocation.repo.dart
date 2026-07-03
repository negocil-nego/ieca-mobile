import 'package:mobile/_import.dart';

abstract class IInvocationRepo {
  Future<Result<List<InvocationContent>>> findContentByInvocation(InvocationTitle invocation);
  Future<Result<InvocationContent>> findContentFist(InvocationTitle invocation);
  Future<Result<List<InvocationTitle>>> findBySection(Section section);
  Future<Result<List<InvocationTitle>>> findFavouritesBySection(Section section);
  Future<Result<void>> updateLastAccessed(int id);
  Future<Result<void>> toggleFavorite(int id);

  Future<int> countBySection(Section section);
  Future<int> count();
}
