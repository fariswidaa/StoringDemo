//import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:StoringDemo/todo_model.dart';

class DBProvider {
  // create a singleton
  DBProvider._();
  static final db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      print("here we first instantiate the ,"
          "data base from previous version ");
      return _database;
    } else {
      print("here we first instantiate the data base ,"
          "a brand new one ");
      return initDB();
    }
  }


  Future<Database> initDB() async {
    final database = await openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'Do_it_DB.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        print("execute the creation of the database with the version number of $version");
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE DO_IT(id INTEGER PRIMARY KEY, title TEXT,age INTEGER)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return database ;
  }

  newTodo(Todo newTodo) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM DO_IT");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into DO_IT (id,title,age)"
        " VALUES (?,?,?)",
        [id, newTodo.title, newTodo.age]);
    print("a new item was inserted to the database, the title is ${newTodo.title}");
    return raw;
  }

  getTodo(int id) async {
    final db = await database;
    var res = await db.query("DO_IT", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Todo.fromMap(res.first) : null;
  }

  Future<List<Todo>> getAllPets() async {
    final db = await database;
    var res = await db.query('DO_IT');

    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];

    print("this method will return all the items ${list.toString()}");
    return list;
  }

  deletePet(int id) async {
    final db = await database;
    print("this item was deleted, its id is $id ") ;
    return db.delete('DO_IT', where: 'id = ?', whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    print("delete all items :P");
    db.rawDelete('Delete * from DO_IT');
  }
}

