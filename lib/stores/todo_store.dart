
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/storage/database_helper.dart';

class TodoStore extends ChangeNotifier {
  List<ToDoModel>? _lstTodo;
  List<ToDoModel>? _lstTodoNotDone;
  List<ToDoModel>? _lstAllTodo;
  List<ToDoModel> get getListTodo => _lstTodo ?? [];
  List<ToDoModel> get getAllListTodo => _lstAllTodo ?? [];
  List<ToDoModel> get getListToDoNotDone => _lstTodoNotDone ?? [];

  ToDoModel newOrUpdateTodoModel = ToDoModel(name: '');
  ToDoModel get getNewOrUpdateTodoModel => newOrUpdateTodoModel;


  /// check show flush bar success or not when insert new todo
  StreamController<bool?> ctrlShowSuccessInsertTodo = StreamController.broadcast();
  Stream<bool?> get showSuccessInsertTodoStream => ctrlShowSuccessInsertTodo.stream;

  /// check show flush bar success or not when update status todo
  StreamController<bool> ctrlShowSuccessUpdateTodo = StreamController.broadcast();
  Stream<bool> get showSuccessUpdateTodoStream => ctrlShowSuccessUpdateTodo.stream;

  Future<void> getTodoList() async {
    var db = DatabaseHelper();
    final result = db.getToDoList();

    result.then((value) {
      _lstAllTodo = value;
      _lstTodo = value.where((element) => element.isDone == 1).toList();
      _lstTodoNotDone= value.where((element) => element.isDone == 0).toList();
      notifyListeners();
    }).catchError((error) {
      print(error.toString());
    });
  }

  void initNewTodo() {
    if(newOrUpdateTodoModel == null) {
      newOrUpdateTodoModel == ToDoModel(
          isDone: 0,
          createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
          name: '',
      );
    }
  }

   void setInsertOrUpdateTodo(ToDoModel model) {
    newOrUpdateTodoModel = model;
    notifyListeners();
   }

  Future<void> insertTodo({required ToDoModel model}) async {
    var db =  DatabaseHelper();
    if(model != null) {
      final future = db.insertToDoLocal(model);
      future.then((check) {
        print("####Insert: "+  check.toString());
        ctrlShowSuccessInsertTodo.add(true);
      }).catchError((error) {
        print("#####: Insert failed");
        ctrlShowSuccessInsertTodo.add(false);
      });
    }
    getTodoList();
  }

  Future<void> updateStatusTodo(ToDoModel model) async {
    var db =  DatabaseHelper();
    ToDoModel completeTodo;
    completeTodo = model;
    completeTodo.isDone = model.isDone == 1 ? 0 : 1;
    final future = db.updateTodoById(completeTodo);
    future.then((check) {
      print("####Update: "+  check.toString());
      ctrlShowSuccessUpdateTodo.add(true);
    }).catchError((error) {
      print("#####: update failed");
      ctrlShowSuccessUpdateTodo.add(false);
    });
    getTodoList();
  }


}