import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

class StorageService {

  static Future<void> saveTasks(List<Task> tasks) async {

    final prefs =
    await SharedPreferences.getInstance();

    List<String> taskList =
    tasks.map((task) =>
        jsonEncode(task.toJson()))
        .toList();

    await prefs.setStringList(
      taskKey,
      taskList,
    );
  }

  static Future<List<Task>> loadTasks() async {

    final prefs =
    await SharedPreferences.getInstance();

    List<String>? taskList =
    prefs.getStringList(taskKey);

    if (taskList == null) {
      return [];
    }

    return taskList
        .map(
          (task) => Task.fromJson(
        jsonDecode(task),
      ),
    )
        .toList();
  }
}