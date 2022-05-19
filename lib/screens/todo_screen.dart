import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/stores/todo_store.dart';

import '../model/todo_model.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  late StreamSubscription<bool?> subShowSuccessInsertTodo;
  late StreamSubscription<bool?> subShowSuccessUpdateTodo;

  TodoStore? todoStore;
  TextEditingController? _textFieldController;
  String _nameTodo = '';
  bool _validate = false;

  @override
  void initState() {
    todoStore = Provider.of<TodoStore>(context, listen: false);
    subShowSuccessInsertTodo = (todoStore?.showSuccessInsertTodoStream
        .listen(_onSuccessOrFaildInsert))!;
    subShowSuccessUpdateTodo = (todoStore?.showSuccessUpdateTodoStream
        .listen(_onSuccessOrFaildUpdate))!;
    getListTodo();
    _textFieldController = TextEditingController(text: '');
    super.initState();
  }

  void getListTodo() async {
    await todoStore?.getTodoList();
    todoStore?.initNewTodo();
  }

  void _onSuccessOrFaildInsert(bool? succeed) {
    if (succeed == true) {
      FlushbarHelper.createSuccess(message: 'Insert Success').show(context);
    } else {
      FlushbarHelper.createError(message: 'Insert Failed').show(context);
    }
  }

  void _onSuccessOrFaildUpdate(bool? succeed) {
    if (succeed == true) {
      FlushbarHelper.createSuccess(message: 'Update Success').show(context);
    } else {
      FlushbarHelper.createError(message: 'Update Failed').show(context);
    }
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration:  InputDecoration(
                hintText: 'Type your new todo',
              filled: true,
              errorText: !_validate ? 'The name can not be blank' : null
            ),
            onSubmitted: (String value) {
              setState(() {
                value.isNotEmpty ? _validate = true : _validate = false;
                _nameTodo = value;
              });
            },

            onChanged: (value) {
              setState(() {
                value.isNotEmpty ? _validate = true : _validate = false;
                _nameTodo = value;
              });
            },
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if(_nameTodo.isNotEmpty) {
                  Navigator.of(context).pop();
                  _insertTodo(_nameTodo);
                }
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _insertTodo(String name) async {
    todoStore?.getNewOrUpdateTodoModel.name = name;
    await todoStore?.insertTodo(model: todoStore!.getNewOrUpdateTodoModel);
  }

  @override
  void dispose() {
    subShowSuccessInsertTodo.cancel();
    subShowSuccessUpdateTodo.cancel();
    _textFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Todo List', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                  onPressed: () {
                    _displayDialog();
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 30.0,
                    color: Colors.blue,
                  )),
            )
          ],
        ),
        body: Consumer<TodoStore>(
          builder: (context, store, child) {
            if (store != null && store.getAllListTodo.isNotEmpty) {
              return _buildTodoList(store.getAllListTodo);
            }
            return Container();
          },
        ));
  }

  _buildTodoList(List<ToDoModel> todos) {
    return ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: todos
            .map((e) => TodoItem(
                  todo: e,
                  onTodoChanged: (e) {
                    todoStore?.updateStatusTodo(e);
                  },
                ))
            .toList());
  }
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final ToDoModel todo;
  Function(ToDoModel model)? onTodoChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged!(todo);
      },
      leading: CircleAvatar(
        child: Text('H'),
      ),
      title: Row(
        children: [
          Text(todo.name, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),),
          const Spacer(),
          todo.isDone == 1
              ? const Icon(
            Icons.done,
            size: 24.0,
            color: Colors.green,
          )
              : Container(),
        ],
      )
    );
  }
}
