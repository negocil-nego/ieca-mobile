import 'package:mobile/_import.dart';

abstract class ISectionService {
  ISectionService({required this.repo});
  final ISectionRepo repo;

  Future<Result<List<Section>>> findAll() => repo.findAll();
  Future<Result<Section>> findDefault() => repo.findDefault();
  Future<Result<Section>> findByCode(String code) => repo.findByCode(code);
  Future<Result<void>> updateDefault(Section section) => repo.updateDefault(section);
}
