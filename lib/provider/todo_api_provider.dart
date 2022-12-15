import 'package:dio/dio.dart';

import '../model/todo_model.dart';
import 'db_provider.dart';

class TodoApiProvider {
  Future<List<TodoModel?>> getAllTodos() async {
    var url = "https://jsonplaceholder.typicode.com/todos";
    Response response = await Dio().get(url);

    return (response.data as List).map((items){
      print('Inserting $items');
      DBProvider.db.insert(TodoModel.fromMap(items));
    }).toList();
  }
}