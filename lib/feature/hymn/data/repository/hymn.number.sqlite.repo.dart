import 'package:mobile/_import.dart';

class HymnNumberSqliteRepo implements IHymnNumberRepo {

  @override
  Future<int> count() async {
    try {
      final db = await openAppDatabase();
      final result = await db.rawQuery('SELECT COUNT(*) as cnt FROM tb_hymns_number WHERE type = ?',
          [HymnNumberType.NORMAL]
      );
      return (result.first['cnt'] as int?) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<int> countBySection(Section section) async {
    try {
      final db = await openAppDatabase();
      final result = await db.rawQuery(
        '''SELECT COUNT(*) as cnt 
           FROM tb_hymns_number hn 
           INNER JOIN tb_hymns_group hg ON hn.hymns_group_id = hg.id 
           WHERE hg.section_id = ? AND hn.type = ?''',
        [section.id, HymnNumberType.NORMAL],
      );
      return (result.first['cnt'] as int?) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<Result<List<HymnsNumber>>> findByHymnsGroup(HymnsGroup hymnsGroup) async {
    try {
      final db = await openAppDatabase();

      final rows = await db.query(
        'tb_hymns_number',
        where: 'hymns_group_id = ? AND type = ?',
        whereArgs: [hymnsGroup.id, HymnNumberType.NORMAL],
        orderBy: 'num ASC',
      );

      final list = rows.map((row) => HymnNumberMapper.toMapper(row, hymnsGroup)).toList();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<HymnsNumber>>> findFavouritesByGroup(HymnsGroup hymnsGroup) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.query(
        'tb_hymns_number',
        where: 'hymns_group_id = ? AND is_favorite = 1 AND type = ?',
        whereArgs: [hymnsGroup.id, HymnNumberType.NORMAL],
        orderBy: 'num ASC',
      );
      final list = rows.map((row) => HymnNumberMapper.toMapper(row, hymnsGroup)).toList();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<HymnsNumber>>> findFavouritesBySection(Section section) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.rawQuery(
        '''SELECT hn.* FROM tb_hymns_number hn
           INNER JOIN tb_hymns_group hg ON hn.hymns_group_id = hg.id
           WHERE hg.section_id = ? AND hn.is_favorite = 1 AND hn.type = ?
           ORDER BY hn.num ASC''',
        [section.id, HymnNumberType.NORMAL],
      );
      final list = rows.map((row) => HymnNumberMapper.toMapper(row, HymnGroupMapper.empty())).toList();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateLastAccessed(int id) async {
    try {
      final db = await openAppDatabase();
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.rawUpdate(
        'UPDATE tb_hymns_number SET last_accessed_at = ?, access_count = access_count + 1 WHERE id = ?',
        [now, id],
      );
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> toggleFavorite(int id) async {
    try {
      final db = await openAppDatabase();
      await db.rawUpdate(
        'UPDATE tb_hymns_number SET is_favorite = CASE WHEN is_favorite = 1 THEN 0 ELSE 1 END WHERE id = ?',
        [id],
      );
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}