import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/stores/todo_store.dart';

class UncompleteTodoScreen extends StatefulWidget {
  const UncompleteTodoScreen({Key? key}) : super(key: key);

  @override
  _UncompleteTodoScreenState createState() => _UncompleteTodoScreenState();
}

class _UncompleteTodoScreenState extends State<UncompleteTodoScreen> {

  TodoStore? todoStore;
  @override
  void initState() {
    todoStore = Provider.of<TodoStore>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Incomplete Todo', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Consumer<TodoStore>(
          builder: (context, store, child) {
            if (store != null && store.getListToDoNotDone.isNotEmpty) {
              return _buildTodoList(store.getListToDoNotDone);
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

