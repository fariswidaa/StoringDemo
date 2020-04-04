import 'dart:async';
import 'package:StoringDemo/database/database.dart';
import 'package:StoringDemo/model/model.dart';

class TodoDao {
final dbProvider = DBProvider.db;

//Adds new Todo records
Future<int> createTodo(Todo todo) async {
final db = await dbProvider.database;
var result = db.insert(todoTABLE, todo.toDatabaseMap());
return result;
}
// Get a single todo item
  getTodo(int id) async {
    final db = await dbProvider.database;
    var res = await db.query( todoTABLE , where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Todo.fromDatabaseMap(res.first) : null;
  }

//Get All Todo items
//Searches if query string was passed
Future<List<Todo>> getTodos({List<String> columns, String query}) async {
final db = await dbProvider.database;

List<Map<String, dynamic>> result;
if (query != null) {
if (query.isNotEmpty)
result = await db.query(todoTABLE,
columns: columns,
where: 'description LIKE ?',
whereArgs: ["%$query%"]);
} else {
result = await db.query(todoTABLE, columns: columns);
}

List<Todo> todos = result.isNotEmpty
? result.map((item) => Todo.fromDatabaseMap(item)).toList()
: [];
return todos;
}

//Update Todo record
Future<int> updateTodo(Todo todo) async {
final db = await dbProvider.database;

var result = await db.update(todoTABLE, todo.toDatabaseMap(),
where: "id = ?", whereArgs: [todo.id]);

return result;
}

//Delete Todo records
Future<int> deleteTodo(int id) async {
final db = await dbProvider.database;
var result = await db.delete(todoTABLE, where: 'id = ?', whereArgs: [id]);

return result;
}

//We are not going to use this in the demo
Future deleteAllTodos() async {
final db = await dbProvider.database;
var result = await db.delete(
todoTABLE,
);

return result;
}

}