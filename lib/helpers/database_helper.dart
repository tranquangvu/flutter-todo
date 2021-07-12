import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_todo/models/task.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'what_todo.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertTask(Task task) async {
    Database _db = await database();

    await _db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> _tasks = await _db.query('tasks');

    return List.generate(_tasks.length, (i) {
      return Task(
        id: _tasks[i]['id'],
        title: _tasks[i]['title'],
        description: _tasks[i]['description'],
      );
    });
  }
}
