import 'package:flutter/material.dart';

import 'package:StoringDemo/todo_model.dart';
import 'package:StoringDemo/database.dart';
import 'dart:math' as math;


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Todo> testItems = [
    Todo(title: 'Read  Fluter', age: 12),
    Todo(title: 'Read  Android', age: 13),
    Todo(title: 'Read  Adobe', age: 132),
    Todo(title: 'Read  UI Design', age: 125),
  ];

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 4.0,
      backgroundColor: Colors.purple,
      title: Text('Do it !'),
    );

    final fab = FloatingActionButton(
      elevation: 6.0,
      tooltip: 'what is the challenge ?',
      focusColor: Colors.blue[200],
      child: Icon(Icons.add),
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue[500],
      onPressed: () async {
        Todo rnd = testItems[math.Random().nextInt(testItems.length)];
        await DBProvider.db.newTodo(rnd);

        setState(() {});
      },
    );

    return MaterialApp(
      title: "Do it !",
      home: Scaffold(
          appBar: appBar,
          body: FutureBuilder<List<Todo>>(

            future: DBProvider.db.getAllPets(),
            builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
              if (snapshot.hasData) {
                print(
                    "This is a snapshot of the data we have ${snapshot.toString()}");
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Todo item = snapshot.data[index];
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {
                        DBProvider.db.deletePet(item.id);
                      },
                      child: ListTile(
                        title: Text(item.title),
                        leading: Text(item.age.toString()),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          floatingActionButton: fab),
    );
  }
}
