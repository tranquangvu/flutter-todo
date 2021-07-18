import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'what_todo.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
        await db.execute(
            'CREATE TABLE todos(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)');
      },
      version: 1,
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

  Future<int> insertTask(Task task) async {
    Database _db = await database();
    Map<String, dynamic> taskMap = task.toMap();

    if (taskMap['id'] == 0) {
      taskMap['id'] = null;
    }

    int createdTaskId = 0;
    await _db.insert(
      'tasks',
      taskMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    ).then((value) {
      createdTaskId = value;
    });

    return createdTaskId;
  }

  Future<void> updateTask(int id, Map<String, dynamic> updatedData) async {
    Database _db = await database();

    await _db.update(
      'tasks',
      updatedData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTask(int taskId) async {
    Database _db = await database();

    await _db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );

    await _db.delete(
      'todos',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
  }

  Future<List<Todo>> getTodos(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> _todos =
        await _db.query('todos', where: '"taskId" = ?', whereArgs: [taskId]);

    return List.generate(_todos.length, (i) {
      return Todo(
        id: _todos[i]['id'],
        title: _todos[i]['title'],
        isDone: _todos[i]['isDone'] == 1,
        taskId: _todos[i]['taskId'],
      );
    });
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    Map<String, dynamic> todoMap = todo.toMap();

    if (todoMap['id'] == 0) {
      todoMap['id'] = null;
    }
    todoMap['isDone'] = todoMap['isDone'] ? 1 : 0;

    await _db.insert(
      'todos',
      todoMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTodo(int id, Map<String, dynamic> updatedData) async {
    Database _db = await database();
    updatedData['isDone'] = updatedData['isDone'] ? 1 : 0;

    await _db.update(
      'todos',
      updatedData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
