import 'package:mobile/_import.dart';

class HymContentBottomSheetViewModel {
  final IHymnContentService _service;
  final IHymnNumberService _numberService;

  HymContentBottomSheetViewModel({
    IHymnContentService? service,
    IHymnNumberService? numberService,
  }) : _service = service ?? HymnContentService(),
       _numberService = numberService ?? HymnNumberService();

  Future<Result<List<HymnsContent>>> findByHymnNumber(HymnsNumber hymnsNumber) async {
    return await _service.findByHymnNumber(hymnsNumber);
  }

  Future<Result<List<HymnsContent>>> search(String search, Section section) async {
    return await _service.search(search, section);
  }

  Future<Result<void>> toggleFavorite(int id) async {
    return await _numberService.toggleFavorite(id);
  }
}
