import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseService {
  static const _dbName = 'app.db';
  static const _dbVersion = 3;

  static const _tableFavorites = 'favorites';
  static const _colId = 'id';
  static const _colUser = 'user';
  static const _colRecipeId = 'recipe_id';

  Database? _db;

  Future<Database> _getDb() async {
    if (_db != null) return _db!;

    final path = p.join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableFavorites (
        $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_colUser TEXT NOT NULL,
        $_colRecipeId INTEGER NOT NULL,
        UNIQUE($_colUser, $_colRecipeId)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      /// Migration from V1 (no user column) to V2.
      await db.execute('''
        CREATE TABLE ${_tableFavorites}_new (
          $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_colUser TEXT NOT NULL,
          $_colRecipeId INTEGER NOT NULL,
          UNIQUE($_colUser, $_colRecipeId)
        )
      ''');
      
      final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='$_tableFavorites'");
      if (tables.isNotEmpty) {
        final rows = await db.query(_tableFavorites, columns: [_colRecipeId]);
        for (final r in rows) {
          final rid = r[_colRecipeId] as int?;
          if (rid != null) {
            await db.insert(
              '${_tableFavorites}_new',
              {_colUser: 'shared', _colRecipeId: rid},
              conflictAlgorithm: ConflictAlgorithm.ignore,
            );
          }
        }
        await db.execute('DROP TABLE $_tableFavorites');
      }

      await db.execute('ALTER TABLE ${_tableFavorites}_new RENAME TO $_tableFavorites');
    }
  }

  Future<List<int>> getFavoriteIds(String user) async {
    final db = await _getDb();
    final rows = await db.query(
      _tableFavorites,
      columns: [_colRecipeId],
      where: '$_colUser = ?',
      whereArgs: [user],
      orderBy: _colId,
    );
    return rows.map((e) => e[_colRecipeId] as int).toList();
  }

  Future<void> addFavorite(String user, int recipeId) async {
    final db = await _getDb();
    await db.insert(
      _tableFavorites,
      {_colUser: user, _colRecipeId: recipeId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeFavorite(String user, int recipeId) async {
    final db = await _getDb();
    await db.delete(
      _tableFavorites,
      where: '$_colUser = ? AND $_colRecipeId = ?',
      whereArgs: [user, recipeId],
    );
  }
}