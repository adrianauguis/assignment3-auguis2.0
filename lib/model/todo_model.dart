// To parse this JSON data, do
//
//     final todoModel = todoModelFromMap(jsonString);

import 'dart:convert';

TodoModel todoModelFromMap(String str) => TodoModel.fromMap(json.decode(str));

String todoModelToMap(TodoModel data) => json.encode(data.toMap());

class TodoModel {
  TodoModel({
    this.userId,
    this.id,
    this.title,
    this.completed,
  });

  int? userId;
  int? id;
  String? title;
  bool? completed;

  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    completed: json["completed"],
  );

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "id": id,
    "title": title,
    "completed": completed,
  };
}
