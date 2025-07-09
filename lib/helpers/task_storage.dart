import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class TaskStorage {
  static const String _tasksKey = 'tasks';

  static Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  static Future<List<Task>> getTasks() async {
    final prefs = await _prefs;
    final String? jsonString = prefs.getString(_tasksKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await _prefs;
    final List<Map<String, dynamic>> jsonList =
        tasks.map((t) => t.toJson()).toList();
    final String jsonString = jsonEncode(jsonList);
    await prefs.setString(_tasksKey, jsonString);
  }
}
