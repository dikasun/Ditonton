import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../models/watchlist/watchlist_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        isMovie INTEGER
      );
    ''');
  }

  Future<int> insertWatchlist(WatchlistTable watchList) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, watchList.toJson());
  }

  Future<int> removeWatchlist(WatchlistTable watchList) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ? AND isMovie = ?',
      whereArgs: [watchList.id, watchList.isMovie],
    );
  }

  Future<Map<String, dynamic>?> getItemById(int id, int isMovie) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ? AND isMovie = ?',
      whereArgs: [id, isMovie],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblWatchlist,
      where: 'isMovie = ?',
      whereArgs: [1],
    );

    return results;
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvShows() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblWatchlist,
      where: 'isMovie = ?',
      whereArgs: [0],
    );

    return results;
  }
}
