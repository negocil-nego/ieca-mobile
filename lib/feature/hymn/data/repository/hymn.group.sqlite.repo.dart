import 'package:mobile/_import.dart';

class HymnGroupSqliteRepo implements IHymnGroupRepo {
  @override
  Future<Result<List<HymnsGroup>>> findBySection(Section section) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.query(
        'tb_hymns_group',
        where: 'section_id = ? AND type = ?',
        whereArgs: [section.id, HymnNumberType.NORMAL],
        orderBy: 'id ASC',
      );
      final groups = rows.map((row) => HymnGroupMapper.toMapper(row, section)).toList();
      return Result.ok(groups);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<HymnsGroup>>> findFavouriteBySection(Section section) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.rawQuery('''
        SELECT DISTINCT g.*
        FROM tb_hymns_group g
        INNER JOIN tb_hymns_number n ON n.hymns_group_id = g.id
        WHERE n.is_favorite = 1 AND g.section_id = ? AND g.type = ?
        ORDER BY g.id ASC
      ''', [section.id, HymnNumberType.NORMAL]);
      final groups = rows.map((row) => HymnGroupMapper.toMapper(row, section)).toList();
      return Result.ok(groups);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
