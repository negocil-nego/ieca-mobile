import 'package:mobile/_import.dart';

class HymnScreenViewmodel {
  final _hymContentBottomSheetViewModel = HymContentBottomSheetViewModel();
  final _hymGroupCategoryViewModel = HymGroupCategoryViewModel();
  final IHymnNumberService _numberService = HymnNumberService();

  Future<Result<List<HymnsContent>>> search(String search, Section section) async {
    return _hymContentBottomSheetViewModel.search(search, section);
  }

  Future<Result<List<HymnsGroup>>> findBySection(Section section) async {
    return _hymGroupCategoryViewModel.findBySection(section);
  }

  Future<Result<void>> updateLastAccessed(int id) async {
    return await _numberService.updateLastAccessed(id);
  }
}