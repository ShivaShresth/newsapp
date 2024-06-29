import 'package:newsapi/sqlitedatabase/favorite_article.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE favoriteArticles (
      id $idType,
      url $textType,
      title $textType,
      description $textType,
      urlToImage $textType
    )
    ''');
  }

  Future<FavoriteArticle> create(FavoriteArticle favoriteArticle) async {
    final db = await instance.database;

    final id = await db.insert('favoriteArticles', favoriteArticle.toMap());
    return favoriteArticle.copy(id: id);
  }

  Future<FavoriteArticle?> readFavoriteArticle(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'favoriteArticles',
      columns: ['id', 'url', 'title', 'description', 'urlToImage'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return FavoriteArticle.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<FavoriteArticle>> readAllFavoriteArticles() async {
    final db = await instance.database;

    final result = await db.query('favoriteArticles');

    return result.map((json) => FavoriteArticle.fromMap(json)).toList();
  }

  Future<int> update(FavoriteArticle favoriteArticle) async {
    final db = await instance.database;

    return db.update(
      'favoriteArticles',
      favoriteArticle.toMap(),
      where: 'id = ?',
      whereArgs: [favoriteArticle.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'favoriteArticles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
