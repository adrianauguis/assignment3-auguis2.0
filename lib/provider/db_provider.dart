import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/todo_model.dart';
import 'package:path/path.dart';

class DBProvider {
  Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database!;

    // If database don't exists, create one
    _database = await open();

    return _database!;
  }

  Future open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Todos.db');

    _database = await openDatabase(path, version: 1,
        onCreate: (Database database, int version) async {
      await database.execute('''
CREATE TABLE Todos ( 
  id INTEGER PRIMARY KEY AUTOINCREMENT, 
  title TEXT NOT NULL,
  completed INTEGER NOT NULL)
''');
    });
  }

  Future<TodoModel?> getTodos() async {
    final db = await database;
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Todos.db');
    var data;
    _database = await openDatabase(path, version: 1,
        onCreate: (Database database, int version) async {
          List<Map> maps = await _database!.rawQuery('SELECT * FROM "Todos"');
          if (maps.isNotEmpty) {
            return maps as Future<void>;
          }
          return;
        });
  }

  Future<TodoModel> insert(TodoModel todo) async {
    todo.id = await _database?.insert('Todos', todo.toMap());
    return todo;
  }

  Future<TodoModel?> getTodo(int id) async {
    List<Map> maps = await _database!.query('Todos',
        columns: ['id', 'completed', 'title'],
        where: '*',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return TodoModel.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }

  Future<TodoModel?> getAllTodos() async {
    List<Map> maps = await _database!.rawQuery('SELECT * FROM "Todos"');

    if (maps.isNotEmpty) {
      return TodoModel.fromMap(maps as Map<String, dynamic>);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await _database!.delete('Todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(TodoModel todo) async {
    return await _database!
        .update('Todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future close() async => _database!.close();
}
