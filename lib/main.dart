import 'package:flutter/material.dart';
import 'package:quizcreator/theme/theme.dart';
import '/screens/start.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  // Ensure plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database when app starts
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'quizzes.db');

  // Open the database
  await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS quizzes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          questions TEXT NOT NULL
        )
      ''');
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Creator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const Start(),
    );
  }
}
