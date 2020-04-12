import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:StoringDemo/bloc/todo_bloc.dart';
import 'package:StoringDemo/model/model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TodoBloc todoBloc = TodoBloc();
  var secondTime = false;
  
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    todoBloc.dispose();
    _todoDescriptionFormController.dispose();
  }

  final DismissDirection _dismissDirection = DismissDirection.horizontal;
  final _todoDescriptionFormController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Do it !',
          style: GoogleFonts.raleway(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Container(
            child: getTodosWidget(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.0),
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
    );
  }

  void _showAddTodoSheet(BuildContext context) {
    editTodoDescribtion(context);
  }

  Widget getTodosWidget() {
    return StreamBuilder(
      stream: todoBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Todo>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Todo todo = snapshot.data[itemPosition];
                final Widget dismissibleCard = InkWell(
                  splashColor: Colors.purple,
                  focusColor: Colors.purple[700],
                  onTap: () {
                    second = true ;
                    editTodoDescribtion(context, todoTask: todo);
                    todoBloc.updateTodo(todo);
                  },
                  child: Dismissible(
                    background: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ),
                      color: Colors.redAccent,
                    ),
                    onDismissed: (direction) {
                      todoBloc.deleteTodoById(todo.id);
                    },
                    direction: _dismissDirection,
                    key: new ObjectKey(todo),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0, right: 8.0),
                      child: ListTile(
                        leading: InkWell(
                          onTap: () {
                            todo.is_done = !todo.is_done;
                            todoBloc.updateTodo(todo);
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: todo.is_done
                                  ? Icon(
                                      Icons.done,
                                      size: 30.0,
                                      color: Colors.indigoAccent,
                                    )
                                  : Icon(
                                      Icons.radio_button_unchecked,
                                      size: 30.0,
                                      color: Colors.blue,
                                    ),
                            ),
                          ),
                        ),
                        title: todo.is_done
                            ? Text(
                                todo.description,
                                style: GoogleFonts.raleway(
                                  fontSize: 18.0,
                                ),
                              )
                            : Text(
                                todo.description,
                                style: GoogleFonts.raleway(
                                  fontSize: 18.0,
                                  // to be implemented later
                                  // make a line that shades the text
                                ),
                              ),
                      ),
                    ),
                  ),
                );
                return dismissibleCard;
              },
            )
          : Container(
              child: Center(
              child: noTodoMessageWidget(),
            ));
    } else {
      return Center(
        child: CircularProgressIndicator(strokeWidth: 2.0),
      );
    }
  }

  Widget noTodoMessageWidget() {
    return Container(
      child: Text(
        'Start your day now !',
        style: GoogleFonts.roboto(
          fontSize: 22.0,
        ),
      ),
    );
  }

  void editTodoDescribtion(BuildContext context, {Todo todoTask}) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 120.0,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          secondTime
                              ? Expanded(
                                  child: TextFormField(
                                    controller: _todoDescriptionFormController,
                                    textInputAction: TextInputAction.newline,
                                    style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w400),
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      labelText: 'New Todo',
                                      labelStyle: TextStyle(
                                        color: Colors.indigoAccent,
                                      ),
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Empty description!';
                                      }
                                      return value.contains('')
                                          ? 'Do not use the @ char.'
                                          : null;
                                    },
                                  ),
                                )
                              : Expanded(
                                  child: TextFormField(
                                    initialValue: todoTask.description,
                                    controller: _todoDescriptionFormController,
                                    textInputAction: TextInputAction.newline,
                                    style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w400),
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      labelText: 'New Todo',
                                      labelStyle: TextStyle(
                                        color: Colors.indigoAccent,
                                      ),
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Empty description!';
                                      }
                                      return value.contains('')
                                          ? 'Do not use the @ char.'
                                          : null;
                                    },
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.save,
                                    size: 24.0,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    final newTodo = Todo(
                                        description:
                                            _todoDescriptionFormController
                                                .value.text);
                                    if (newTodo.description.isNotEmpty) {
                                      todoBloc.addTodo(newTodo);
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.date_range,
                                    size: 24.0,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    // TODO-implement the time picking functionality
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

   set second(bool value) => secondTime = value ;
}
