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

  HymnsGroup _mapGroup(Map<String, Object?> row, Section section) {
    return HymnsGroup(
      id: row['g_id'] as int,
      name: row['g_name'] as String,
      beginning: row['g_beginning'] as int,
      finished: row['g_finished'] as int,
      section: section,
    );
  }

  @override
  Future<Result<List<HymnsNumber>>> findLastAccessedBySection(Section section, {int limit = 10}) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.rawQuery('''
        SELECT hn.*, hg.id as g_id, hg.name as g_name, hg.beginning as g_beginning, hg.finished as g_finished
        FROM tb_hymns_number hn
        INNER JOIN tb_hymns_group hg ON hn.hymns_group_id = hg.id
        WHERE hg.section_id = ? AND hn.last_accessed_at IS NOT NULL AND hn.type = ?
        ORDER BY hn.last_accessed_at DESC LIMIT ?
      ''', [section.id, HymnNumberType.NORMAL, limit]);
      final list = rows.map((row) => HymnNumberMapper.toMapper(row, _mapGroup(row, section))).toList();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<HymnsNumber>>> findMostAccessedBySection(Section section, {int limit = 10}) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.rawQuery('''
        SELECT hn.*, hg.id as g_id, hg.name as g_name, hg.beginning as g_beginning, hg.finished as g_finished
        FROM tb_hymns_number hn
        INNER JOIN tb_hymns_group hg ON hn.hymns_group_id = hg.id
        WHERE hg.section_id = ? AND hn.type = ?
        ORDER BY hn.access_count DESC LIMIT ?
      ''', [section.id, HymnNumberType.NORMAL, limit]);
      final list = rows.map((row) => HymnNumberMapper.toMapper(row, _mapGroup(row, section))).toList();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<HymnsNumber?>> findNext(HymnsNumber current) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.rawQuery('''
        SELECT hn.*, hg.id as g_id, hg.name as g_name, hg.beginning as g_beginning, hg.finished as g_finished
        FROM tb_hymns_number hn
        INNER JOIN tb_hymns_group hg ON hn.hymns_group_id = hg.id
        WHERE hg.section_id = ? AND hn.num > ? AND hn.type = ?
        ORDER BY hn.num ASC LIMIT 1
      ''', [current.hymnsGroup.section.id, current.num, HymnNumberType.NORMAL]);
      if (rows.isEmpty) return Result.ok(null);
      final group = _mapGroup(rows.first, current.hymnsGroup.section);
      return Result.ok(HymnNumberMapper.toMapper(rows.first, group));
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<HymnsNumber?>> findPrevious(HymnsNumber current) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.rawQuery('''
        SELECT hn.*, hg.id as g_id, hg.name as g_name, hg.beginning as g_beginning, hg.finished as g_finished
        FROM tb_hymns_number hn
        INNER JOIN tb_hymns_group hg ON hn.hymns_group_id = hg.id
        WHERE hg.section_id = ? AND hn.num < ? AND hn.type = ?
        ORDER BY hn.num DESC LIMIT 1
      ''', [current.hymnsGroup.section.id, current.num, HymnNumberType.NORMAL]);
      if (rows.isEmpty) return Result.ok(null);
      final group = _mapGroup(rows.first, current.hymnsGroup.section);
      return Result.ok(HymnNumberMapper.toMapper(rows.first, group));
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