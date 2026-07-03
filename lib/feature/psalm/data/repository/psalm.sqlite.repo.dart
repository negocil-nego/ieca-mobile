import 'package:mobile/_import.dart';

class PsalmSqliteRepo implements IPsalmRepo {
  @override
  Future<int> count() async {
    try {
      final db = await openAppDatabase();
      final result = await db.rawQuery('SELECT COUNT(*) as cnt FROM tb_psalms_title');
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
        'SELECT COUNT(*) as cnt FROM tb_psalms_title WHERE section_id = ?',
        [section.id],
      );
      return (result.first['cnt'] as int?) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<Result<List<PsalmsTitle>>> findBySection(Section section) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.query(
        'tb_psalms_title',
        where: 'section_id = ?',
        whereArgs: [section.id],
        orderBy: 'position ASC',
      );
      final titles = rows.map((row) => PsalmsMapper.toMapper(row, section)).toList();
      return Result.ok(titles);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<PsalmsContent>>> findContentByPsalmsTitle(PsalmsTitle psalmsTitle) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.query(
        'tb_psalms_content',
        where: 'psalms_title_id = ?',
        whereArgs: [psalmsTitle.id],
        orderBy: 'position ASC',
      );
      final list = rows.map((row) => PsalmsContentMapper.toMapper(row, psalmsTitle)).toList();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<PsalmsContent>> findContentFist(PsalmsTitle psalmsTitle) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.query(
        'tb_psalms_content',
        where: 'psalms_title_id = ?',
        whereArgs: [psalmsTitle.id],
        orderBy: 'position ASC',
      );
      if (rows.isEmpty) return Result.error(Exception('No content found'));
      return Result.ok(PsalmsContentMapper.toMapper(rows.first, psalmsTitle));
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<PsalmsTitle>>> findFavouritesBySection(Section section) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.query(
        'tb_psalms_title',
        where: 'section_id = ? AND is_favorite = 1',
        whereArgs: [section.id],
        orderBy: 'position ASC',
      );
      final titles = rows.map((row) => PsalmsMapper.toMapper(row, section)).toList();
      return Result.ok(titles);
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
        'UPDATE tb_psalms_title SET last_accessed_at = ?, access_count = access_count + 1 WHERE id = ?',
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
        'UPDATE tb_psalms_title SET is_favorite = CASE WHEN is_favorite = 1 THEN 0 ELSE 1 END WHERE id = ?',
        [id],
      );
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
