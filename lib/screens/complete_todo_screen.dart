import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/stores/todo_store.dart';

import '../model/todo_model.dart';

class CompleteTodoScreen extends StatefulWidget {
  const CompleteTodoScreen({Key? key}) : super(key: key);

  @override
  _CompleteTodoScreenState createState() => _CompleteTodoScreenState();
}

class _CompleteTodoScreenState extends State<CompleteTodoScreen> {
  TodoStore? todoStore;

  @override
  void initState() {
    // TODO: implement initState
    todoStore = Provider.of<TodoStore>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Complete Todo', style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Consumer<TodoStore>(
          builder: (context, store, child) {
            if (store != null && store.getListTodo.isNotEmpty) {
              return _buildTodoList(store.getListTodo);
            }
            return Container();
          },
        ));
  }

  _buildTodoList(List<ToDoModel> todos) {
    return ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: todos.map((e) {
          return TodoItem(todo: e);
        }).toList()
    );
  }
}
