// lib/services/database_service.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService instance = DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'recipes.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY
      )
    ''');
  }

  Future<void> addFavorite(int id) async {
    final db = await database;
    await db.insert(
      'favorites',
      {'id': id},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<Set<int>> getFavoriteIds() async {
    final db = await database;
    final rows = await db.query('favorites', columns: ['id']);
    return rows.map((e) => e['id'] as int).toSet();
  }

  Future<bool> isFavorite(int id) async {
    final db = await database;
    final rows =
        await db.query('favorites', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isNotEmpty;
  }

  Future<bool> toggleFavorite(int id) async {
    final currentlyFavorite = await isFavorite(id);
    
    // ✅ PERBAIKAN: Tambahkan print di sini
    print('[Database] Toggling favorite for ID: $id. Is it currently favorite? $currentlyFavorite');

    if (currentlyFavorite) {
      print('[Database] -> Removing $id from favorites table.');
      await removeFavorite(id);
      return false; // Sekarang sudah tidak favorit
    } else {
      print('[Database] -> Adding $id to favorites table.');
      await addFavorite(id);
      return true; // Sekarang sudah jadi favorit
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db != null && db.isOpen) {
      await db.close();
      _db = null;
    }
  }
}