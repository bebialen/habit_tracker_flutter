//hive db 





// Sqflite
// Database Helper Class
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:habit_tracker/add_habit_page.dart/local/models.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habits_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        frequency TEXT NOT NULL, 
        isDone INTEGER NOT NULL DEFAULT 0
        
      )
    ''');
  }

  // Insert a habit into the database
  Future<int> insertHabit(Habit habit) async {
    final db = await database;
    return await db.insert(
      'habits', 
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all habits
  Future<List<Habit>> getAllHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('habits');

    return List.generate(maps.length, (i) {
      return Habit.fromMap(maps[i]);
    });
  }


  // Update a habit
  Future<int> updateHabit(Habit habit) async {
    final db = await database;
    habit = Habit(
    id: habit.id,
    name: habit.name,
    description: habit.description,
    frequency: habit.frequency,
    isDone: 1, 
  );
    
    return await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ? ',
      whereArgs: [habit.id],
    );
  }

  // Delete a habit
  Future<int> deleteHabit(int id) async {
    final db = await database;
    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


}