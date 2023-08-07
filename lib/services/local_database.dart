import 'package:e_commerce/services/news_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();

  LocalDatabase._init();

  factory LocalDatabase() {
    return getInstance;
  }


  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("news.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE news(
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        image TEXT NOT NULL
      )
    ''');
  }


  static Future<NewsModel> insertNews(
      NewsModel newsModel) async {
    final db = await getInstance.database;
    final int id = await db.insert(
        "news", newsModel.toJson());
    return newsModel ;
  }

  static Future<List<NewsModel>> getAllNews() async {
    final db = await getInstance.database;
    final List<Map<String, dynamic>> maps = await db.query('news');
    return List.generate(maps.length, (i) {
      return NewsModel.fromJson(maps[i]);
    });
  }

  static Future<void> delete() async {
    final db = await getInstance.database;
    await db.delete(
        'products'
    );
  }

}
