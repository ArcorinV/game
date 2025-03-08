import 'package:game/core/models/armor/armor.dart';
import 'package:game/core/models/hero.dart';
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
      version: 6,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE hero(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        level INTEGER,
        experience INTEGER,
        gold INTEGER,
        date_battle TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE hero_armor(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hero_id INTEGER,
        armor_id INTEGER,
        name TEXT,
        defense INTEGER,
        rarity INTEGER,
        type_armor_weight INTEGER,
        type_armor INTEGER,
        date_received TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE hero_battle(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hero_id INTEGER,
        date_battle TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE hero_status(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hero_id INTEGER,
        last_login TEXT,
        health INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  /// Hero methods
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

  /// Armor methods
  Future<int> insertHeroArmor(int heroId, ArmorModel armor) async {
    Database db = await database;
    final armorLength = (await db.query('hero_armor')).length;
    return await db.insert('hero_armor', {
      'hero_id': heroId,
      'armor_id': armorLength + 1,
      'name': armor.name,
      'date_received': DateTime.now().toIso8601String(),
      'defense': armor.defense,
      'rarity': armor.rarity.index,
      'type_armor_weight': armor.typeArmorWeight.index,
      'type_armor': armor.typeArmor.index,
    });
  }

  Future<DateTime?> getLastArmorReceivedDate(int heroId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'hero_armor',
      where: 'hero_id = ?',
      whereArgs: [heroId],
      orderBy: 'date_received DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return DateTime.parse(maps.first['date_received']);
    }
    return null;
  }

  Future<List<ArmorModel>> getArmors(int heroId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'hero_armor',
      where: 'hero_id = ?',
      whereArgs: [heroId],
      orderBy: 'date_received DESC',
    );
    return maps.map((map) => ArmorModel.fromMap(map)).toList();
  }

  Future<int> insertHeroBattle(int heroId) async {
    Database db = await database;
    return await db.insert('hero_battle', {
      'hero_id': heroId,
      'date_battle': DateTime.now().toIso8601String(),
    });
  }

  Future<List<DateTime>> getHeroBattles(int heroId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'hero_battle',
      where: 'hero_id = ?',
      whereArgs: [heroId],
      orderBy: 'date_battle DESC',
    );
    return maps.map((map) => DateTime.parse(map['date_battle'])).toList();
  }

  Future<int> insertHeroStatus(int heroId, DateTime lastLogin, int health) async {
    Database db = await database;
    return await db.insert('hero_status', {
      'hero_id': heroId,
      'last_login': lastLogin.toIso8601String(),
      'health': health,
    });
  }

  Future<int?> getHeroStatus(int heroId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'hero_status',
      where: 'hero_id = ?',
      whereArgs: [heroId],
      orderBy: 'last_login DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      final oldHP = maps.first;
      final lastLogit = DateTime.parse(oldHP['last_login']);
      if (lastLogit.isBefore(DateTime.now().subtract(Duration(days: 1))) && oldHP['health'] < 100) {
        final hoursCount = DateTime.now().difference(lastLogit).inHours;
        final restoredHP = hoursCount * 10;
        final health = oldHP['health'] + restoredHP > 100 ? 100 : oldHP['health'] + restoredHP;
        await db.update(
          'hero_status',
          {'health': health},
          where: 'hero_id = ?',
          whereArgs: [heroId],
        );
        return health;
      }
    }
    return null;
  }

  Future<void> updateHeroHealth(int heroId, int health) async {
    Database db = await database;
    await db.update(
      'hero_status',
      {'health': health},
      where: 'hero_id = ?',
      whereArgs: [heroId],
    );
  }
}
