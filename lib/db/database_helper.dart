import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'activities.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS activities (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            name TEXT,
            duration TEXT,
            date TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS daily_summary (
            user_id INTEGER,
            date TEXT,
            steps INTEGER,
            water INTEGER,
            PRIMARY KEY (user_id, date)
          );
        ''');
      },
    );
  }

  // 🔹 Insert activity
  Future<void> insertActivity(int userId, String name, String duration, String date) async {
    final db = await database;
    await db.insert(
      'activities',
      {
        'user_id': userId,
        'name': name,
        'duration': duration,
        'date': date,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 🔹 Get activities by date
  Future<List<Map<String, dynamic>>> getActivitiesByDate(int userId, String date) async {
    final db = await database;
    return await db.query(
      'activities',
      where: 'user_id = ? AND date = ?',
      whereArgs: [userId, date],
      orderBy: 'id DESC',
    );
  }

  // 🔹 Update activity by ID
  Future<void> updateActivity(int id, Map<String, dynamic> newData) async {
    final db = await database;
    await db.update(
      'activities',
      newData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 🔹 Delete activity by ID
  Future<void> deleteActivity(int id) async {
    final db = await database;
    await db.delete(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 🔹 Save or update daily summary (steps + water)
  Future<void> saveDailySummary(int userId, int steps, int water) async {
    final db = await database;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await db.insert(
      'daily_summary',
      {
        'user_id': userId,
        'date': today,
        'steps': steps,
        'water': water,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 🔹 Get daily summary by date
  Future<Map<String, dynamic>> getDailySummaryByDate(int userId, String date) async {
    final db = await database;
    final result = await db.query(
      'daily_summary',
      where: 'user_id = ? AND date = ?',
      whereArgs: [userId, date],
    );
    return result.isNotEmpty ? result.first : {'steps': 0, 'water': 0};
  }

  // 🔹 Delete all user data (if needed)
  Future<void> deleteUserData(int userId) async {
    final db = await database;
    await db.delete('activities', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete('daily_summary', where: 'user_id = ?', whereArgs: [userId]);
  }

  // 🔹 Delete the whole database file
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'activities.db');
    await deleteDatabase(path);
  }
}
