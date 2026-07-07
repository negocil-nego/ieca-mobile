import 'package:mobile/_import.dart';

abstract class IHymnGroupRepo {
  Future<Result<List<HymnsGroup>>> findBySection(Section section);
  Future<Result<List<HymnsGroup>>> findAdditionalBySection(Section section);
  Future<Result<List<HymnsGroup>>> findFavouriteBySection(Section section);
}
