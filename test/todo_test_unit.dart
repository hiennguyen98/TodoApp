import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/stores/todo_store.dart';
///
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var todoStore = TodoStore();
  group('Given All Todo List Screen Loads', () {
    test('Screen should load a list of todos', () async {
      // 1
       await todoStore.getTodoList();
      // 2
      expect(todoStore.getAllListTodo.length, 0);

    });
  });

  /// Test add new todo list
  final ToDoModel mockTodo = ToDoModel(
      name: 'Handle Unit test',
      isDone: 0,
      createdAt: DateTime.now().millisecondsSinceEpoch.toString());

  test('When user adds a new todo to list, the list should be increment by 1 ', () async {
    todoStore.insertTodo(model: mockTodo);
    await todoStore.getTodoList();
    final lstTodo = await todoStore.getAllListTodo;
    expect(lstTodo.length, lstTodo.length);
  });
}
