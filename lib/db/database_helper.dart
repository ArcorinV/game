import 'package:flutter_application_1/core/hero.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'game.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE hero(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        level INTEGER,
        experience INTEGER
      )
    ''');
  }

  Future<int> insertHero(HeroModel hero) async {
    Database db = await database;
    return await db.insert('hero', hero.toMap());
  }

  Future<HeroModel?> getHero(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'hero',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return HeroModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateHero(HeroModel hero) async {
    Database db = await database;
    return await db.update(
      'hero',
      hero.toMap(),
      where: 'id = ?',
      whereArgs: [hero.id],
    );
  }
}
