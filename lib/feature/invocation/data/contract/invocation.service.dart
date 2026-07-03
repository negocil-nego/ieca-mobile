import 'package:mobile/_import.dart';
abstract class IInvocationService {
  IInvocationService({required this.repo});
  final IInvocationRepo repo;

  Future<Result<List<InvocationContent>>> findContentByInvocation(InvocationTitle invocation) => repo.findContentByInvocation(invocation);
  Future<Result<InvocationContent>> findContentFist(InvocationTitle invocation) => repo.findContentFist(invocation);
  Future<Result<List<InvocationTitle>>> findBySection(Section section) => repo.findBySection(section);
  Future<Result<List<InvocationTitle>>> findFavouritesBySection(Section section) => repo.findFavouritesBySection(section);
  Future<Result<void>> updateLastAccessed(int id) => repo.updateLastAccessed(id);
  Future<Result<void>> toggleFavorite(int id) => repo.toggleFavorite(id);
  Future<int> countBySection(Section section) => repo.countBySection(section);
  Future<int> count() => repo.count();
}
