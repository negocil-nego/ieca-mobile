import 'package:mobile/_import.dart';

class InvocationSqliteRepo implements IInvocationRepo {
  @override
  Future<int> count() async {
    try {
      final db = await openAppDatabase();
      final result = await db.rawQuery('SELECT COUNT(*) as cnt FROM tb_invocation_title');
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
        'SELECT COUNT(*) as cnt FROM tb_invocation_title WHERE section_id = ?',
        [section.id],
      );
      return (result.first['cnt'] as int?) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<Result<List<InvocationTitle>>> findBySection(Section section) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.query(
        'tb_invocation_title',
        where: 'section_id = ?',
        whereArgs: [section.id],
        orderBy: 'position ASC',
      );
      final list = rows.map((row) => InvocationMapper.toMapper(row, section)).toList();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<InvocationContent>>> findContentByInvocation(InvocationTitle invocation) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.query(
        'tb_invocation_content',
        where: 'invocation_title_id = ?',
        whereArgs: [invocation.id],
        orderBy: 'position ASC',
      );
      final list = rows.map((row) => InvocationContentMapper.toMapper(row, invocation)).toList();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<InvocationContent>> findContentFist(InvocationTitle invocation) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.query(
        'tb_invocation_content',
        where: 'invocation_title_id = ?',
        whereArgs: [invocation.id],
        orderBy: 'position ASC',
        limit: 1,
      );
      if (rows.isEmpty) return Result.error(Exception('No content found'));
      return Result.ok(InvocationContentMapper.toMapper(rows.first, invocation));
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<InvocationTitle>>> findLastAccessedBySection(Section section, {int limit = 10}) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.query(
        'tb_invocation_title',
        where: 'section_id = ? AND last_accessed_at IS NOT NULL',
        whereArgs: [section.id],
        orderBy: 'last_accessed_at DESC',
        limit: limit,
      );
      final list = rows.map((row) => InvocationMapper.toMapper(row, section)).toList();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<InvocationTitle>>> findMostAccessedBySection(Section section, {int limit = 10}) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.query(
        'tb_invocation_title',
        where: 'section_id = ?',
        whereArgs: [section.id],
        orderBy: 'access_count DESC',
        limit: limit,
      );
      final list = rows.map((row) => InvocationMapper.toMapper(row, section)).toList();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<InvocationTitle>>> search(String search, Section section) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.rawQuery('''
        SELECT DISTINCT t.*
        FROM tb_invocation_title t
        INNER JOIN tb_invocation_content c ON c.invocation_title_id = t.id
        WHERE c.content LIKE ? AND t.section_id = ?
        ORDER BY t.position ASC
      ''', ['%$search%', section.id]);
      final list = rows.map((row) => InvocationMapper.toMapper(row, section)).toList();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<InvocationTitle>>> findFavouritesBySection(Section section) async {
    try {
      final db = await openAppDatabase();
      final rows = await db.query(
        'tb_invocation_title',
        where: 'section_id = ? AND is_favorite = 1',
        whereArgs: [section.id],
        orderBy: 'position ASC',
      );
      final list = rows.map((row) => InvocationMapper.toMapper(row, section)).toList();
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
        'UPDATE tb_invocation_title SET last_accessed_at = ?, access_count = access_count + 1 WHERE id = ?',
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
        'UPDATE tb_invocation_title SET is_favorite = CASE WHEN is_favorite = 1 THEN 0 ELSE 1 END WHERE id = ?',
        [id],
      );
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
