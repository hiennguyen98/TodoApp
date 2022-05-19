import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:todo_app/model/todo_model.dart';

class DatabaseHelper {
  static const TODO_TABLE = 'todo_table';

  static const String TODO_SQL = """CREATE TABLE $TODO_TABLE(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT, 
    isDone INTEGER,
    createdAt TEXT, 
    dateDone TEXT    
  )""";

  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;
  DatabaseHelper.internal();

  Future<Database> get db async {
    if(_db !=null) return  _db!;
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await pathProvider.getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app_db');
    var theDb = await openDatabase(
        path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }

  _onCreate(Database db, int version) async {
    await db.execute(TODO_SQL);
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {

  }
  /// INSERT AN TODO TO LOCAL
  Future<int> insertToDoLocal (ToDoModel toDoModel) async {
    var dbClient = await db;
    var result = await dbClient.insert(TODO_TABLE, toDoModel.toJson());
    return result;
  }

  /// GET ALL TODO LIST
  Future<List<ToDoModel>> getToDoList() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient.query(TODO_TABLE, orderBy: 'id DESC');
    return List.generate(result.length, (i) {
      return ToDoModel(
        id: result[i]['id'],
        name: result[i]['name'],
        createdAt: result[i]['createdAt'],
        isDone: result[i]['isDone'],
      );
    });
  }

  /// UPDATE AN TODO
  Future<int> updateTodoById (ToDoModel model) async {
    var dbClient = await db;
    var result = await dbClient.update(TODO_TABLE, model.toJson(), where: "id = ?", whereArgs: [model.id]);
    return result;
  }
}