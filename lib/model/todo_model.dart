
class ToDoModel {
  int? id;
  String name;
  int isDone;
  String? createdAt;

  ToDoModel({this.id, required this.name, this.isDone = 0, this.createdAt});

  factory ToDoModel.fromMap(Map<String, dynamic> json) {
    return ToDoModel(id: json['id'], name: json['name'], isDone: json['isDone']);
  }

  Map<String, dynamic> toJson() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['name'] = name;
    map['isDone'] = isDone;

    return map;
  }

}