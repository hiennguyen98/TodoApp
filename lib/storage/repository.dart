
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/storage/database_helper.dart';

class Repository {
  final DatabaseHelper _databaseHelper;

  Repository(this._databaseHelper);

  Future<List<ToDoModel>> getListToDo() async {
    return await _databaseHelper.getToDoList();
  }

  Future<int> insertTodoLocal(ToDoModel model) => _databaseHelper
      .insertToDoLocal(model)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> updateTodoLocal(ToDoModel model) => _databaseHelper
      .updateTodoById(model)
      .then((id) => id)
      .catchError((error) => throw error);
}