
class Todo {
  int id ;
  String title ;
  int age ;
  
  Todo({this.title, this.age, this.id});

  factory Todo.fromMap(Map<String, dynamic> json) => new Todo(
    id : json["id"],
    title: json["title"],
    age: json["age"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "id": id,
    "age": age
  };

//  Pet clientFromJson(String str) {
//    final jsonData = json.decode(str);
//    return Client.fromMap(jsonData);
//  }
//
//  String clientToJson(Client data) {
//    final dyn = data.toMap();
//    return json.encode(dyn);
//  }

}
