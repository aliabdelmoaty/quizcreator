import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quizzes.db');
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

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE quizzes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        questions TEXT NOT NULL
      )
    ''');
  }

  Future<int> createQuiz(String title, String questions) async {
    final db = await database;
    final data = {
      'title': title,
      'questions': questions,
    };
    return await db.insert('quizzes', data);
  }

  Future<List<Map<String, dynamic>>> getAllQuizzes() async {
    final db = await database;
    return await db.query('quizzes');
  }

  Future<List<Map<String, dynamic>>> getQuizzes() async {
    final db = await database;
    return await db.query('quizzes');
  }

  Future<void> deleteQuiz(String title) async {
    final db = await database;
    await db.delete(
      'quizzes',
      where: 'title = ?',
      whereArgs: [title],
    );
  }
}
