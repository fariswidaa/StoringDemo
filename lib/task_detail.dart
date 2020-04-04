import 'package:flutter/material.dart';

void main() => runApp(Task());

class Task extends StatefulWidget {
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final appBar = AppBar(
    elevation: 4.0,
    backgroundColor: Colors.purple,
    title: Text('Add a task'),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: appBar,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child:TextField(
                  autocorrect: true,
                  /**
                   * TODO 
                   * to be completed ... 
                   * 
                   */
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
