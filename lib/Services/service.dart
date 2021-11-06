import 'dart:convert';

import 'package:http/http.dart';
import 'package:tasky_watcher_app/Model/taskyModel.dart';

class TaskService {
  //get all tasks
  Future<TaskyManagerApi> getAllTasks() async {
    Response response =
        await get(Uri.parse("https://taskmanagerghana.herokuapp.com/tasks"));

    if (response.statusCode == 200) {
      // print(response.body);
      var data = jsonDecode(response.body);

      return TaskyManagerApi.fromJson(data);
    } else {
      throw {Exception("Failed to load todo")};
    }
  }

////post task

  Future postTask(
      {required String title,
      required String description,
      required bool isCompleted}) async {
    Map<String, dynamic> body = {
      "title": title,
      "description": description,
      "isCompleted": isCompleted.toString()
    };
    return await post(
      Uri.parse("https://taskmanagerghana.herokuapp.com/create"),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  ////Update Task
  Future updateTask({required String id, required bool isCompleted}) async {
    Map<String, String> body = {"isCompleted": isCompleted.toString()};

    return await patch(
      Uri.parse("https://taskmanagerghana.herokuapp.com/tasks/$id"),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  ////Delete Task
  Future deletedTask(String id) async {
    return await delete(
        Uri.parse("https://taskmanagerghana.herokuapp.com/tasks/$id"));
  }
}
