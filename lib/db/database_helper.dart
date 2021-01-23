import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_todo/model/todo.dart';

import '../model/task.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        await db.execute(
            "CREATE TABLE todo(id INTEGER PRIMARY KEY,taskId INTEGER, title TEXT, isDone INTEGER)");

        return db;
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int _taskId = 0;
    final _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      _taskId = value;
    });
    return _taskId;
  }

  Future<void> updateTask(int id, String title) async {
    final _db = await database();
    await _db.rawQuery("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateDescription(int id, String description) async {
    final _db = await database();
    await _db.rawQuery(
        "UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  Future<void> insertTodo(Todo todo) async {
    final _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTodoDone(int id , int isDone) async {
    final _db = await database();
    await _db.rawQuery("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  Future<void> deleteTask(int id) async {
    final _db = await database();
    await _db.rawDelete("DELETE FROM tasks  WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo  WHERE taskId = '$id'");
  }

  Future<void> deleteTodo(int isDone) async {
    final _db = await database();
    await _db.rawDelete("DELETE FROM todo  WHERE isDone = '$isDone' ");
  }

  Future<List<Task>> getTask() async {
    final _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
        id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        description: taskMap[index]['description'],
      );
    });
  }

  Future<List<Todo>> getTodo(int taskId) async {
    final _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery('SELECT * FROM todo WHERE taskId = $taskId');
    return List.generate(todoMap.length, (index) {
      return Todo(
        id: todoMap[index]['id'],
        taskId: todoMap[index]['taskId'],
        title: todoMap[index]['title'],
        isDone: todoMap[index]['isDone'],
      );
    });
  }
}
