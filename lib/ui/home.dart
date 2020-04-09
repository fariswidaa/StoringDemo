import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:StoringDemo/bloc/todo_bloc.dart';
import 'package:StoringDemo/model/model.dart';

import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TodoBloc todoBloc;

  void initState() {
  print ('the init state');
    super.initState();
    todoBloc = TodoBloc();
  }

  void dispose() {
  print ('the dispose method');
    super.dispose();
    todoBloc.dispose();
  }

  final appBar = AppBar(
    elevation: 4.0,
    backgroundColor: Colors.purple,
    title: Text('Do it !'),
  );

  @override
  Widget build(BuildContext context) {
  print ('the build widget');
    return MaterialApp(
      title: 'Do it !',
      home: Scaffold(
        appBar: appBar,
        body:
        // SafeArea(
          Container(
            child: getTodoWidget(),
          ),
        //),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 25),
          child: FloatingActionButton(
            elevation: 5.0,
            onPressed: () {
              _showAddTodoSheet(context);
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              size: 32,
              color: Colors.indigoAccent,
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTodoWidget() {
    return StreamBuilder(
      stream: todoBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Todo>> snapshot) {
    if (snapshot.hasData) {
    print('here is the snapshot');
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Todo todo = snapshot.data[itemPosition];
                    print('here is the item builder');
                final Widget dismissibleCard = new Dismissible(
                  background: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Deleting",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    color: Colors.redAccent,
                  ),
                  onDismissed: (direction) {
                    todoBloc.deleteTodoById(todo.id);
                  },
                  direction: DismissDirection.horizontal,
                  key: new ObjectKey(todo),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey[200], width: 0.5),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Colors.white,
                    child: ListTile(
                      leading: InkWell(
                        onTap: () {
                          todo.is_done = !todo.is_done;
                          todoBloc.updateTodo(todo);
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: todo.is_done
                                ? Icon(
                                    Icons.done,
                                    size: 26.0,
                                    color: Colors.indigoAccent,
                                  )
                                : Icon(
                                    Icons.check_box_outline_blank,
                                    size: 26.0,
                                    color: Colors.tealAccent,
                                  ),
                          ),
                        ),
                      ),
                      title: Text(
                        todo.description,

                      ),
                    ),
                  ),
                );
                return dismissibleCard;
              },
            )
          : Container(
              child: Center(
              //this is used whenever there 0 Todo
              //in the data base
              child: noTodoMessageWidget(),
            ));
    } else {
    print ('circular progress');
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      );
    }
  }

  Widget noTodoMessageWidget() {
  print ('no todo message ');
    return Container(
    child :Center(
      child: Text(
        "Start your day right :D",
      ),
      ),
    );
  }

  void _showAddTodoSheet(BuildContext context) {
    final _todoDescriptionFormController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: new Container(
            color: Colors.transparent,
            child: new Container(
              // was 230
              height: 100,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(5.0),
                  topRight: const Radius.circular(5.0),
                ),
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(left: 15, top: 25.0, right: 15, bottom: 30),
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _todoDescriptionFormController,
                            textInputAction: TextInputAction.newline,
                            maxLines: 2,
 
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'I have to...',
                              labelText: 'New Todo',
                              labelStyle: TextStyle(
                                  color: Colors.indigoAccent,
                                  fontWeight: FontWeight.w500),
                            ),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Empty task!';
                              }
                              return value.contains('')
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5, top: 15),
                          child: CircleAvatar(
                            backgroundColor: Colors.indigoAccent,
                            radius: 18,
                            child: IconButton(
                              icon: Icon(
                                Icons.save,
                                size: 22,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                final newTodo = Todo(
                                    description: _todoDescriptionFormController
                                        .value.text);
                                if (newTodo.description.isNotEmpty) {
                                  todoBloc.addTodo(newTodo);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
