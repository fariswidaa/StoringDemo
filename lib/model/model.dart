
class Todo {
  int id ;
  String description ;
  bool is_done = false ;
  
  Todo({this.description, this.id, this.is_done = false});

  factory Todo.fromDatabaseMap(Map<String, dynamic> json) => new Todo(
    id : json["id"],
    description: json["description"],
    is_done: json["is_done"] == 0 ? false : true,
  );

  Map<String, dynamic> toDatabaseMap() => {
    "id": id,
    "description": description,
    "is_done": is_done == false ? 0 : 1,
  };

}