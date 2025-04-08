import 'dart:convert';
import 'package:flutter_application_todoapp/model/task.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TodoService {
  final String apiUrl =
      'http://10.0.2.2:5137/api/todo'; // Adjust the URL as needed

  // Fetch User Todos
  Future<List<dynamic>?> fetchTodos(int userId) async {
    final token = await _getToken();
    if (token == null) {
      return null; // No token means not authenticated
    }

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/user/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Fetch Todos failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in fetchTodos: $e');
      return null;
    }
  }

  // Add Todo
  Future<bool> addTask(Task newTask) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': newTask.userId,
          'type':
              newTask.type.toString().split('.').last, // Convert enum to string
          'title': newTask.title,
          'description': newTask.description,
          'date': newTask.date,
          'time': newTask.time,
          'isCompleted': newTask.isCompleted,
        }),
      );

      if (response.statusCode == 201) {
        // Success
        return true;
      } else {
        print('Failed to add task: ${response.body}');
        // Handle error
        return false;
      }
    } catch (e) {
      print('Error adding task: $e');
      // Handle exceptions
      return false;
    }
  }

  // Update Todo
  Future<bool> updateTodo(int userId, Map<String, dynamic> todo) async {
    final token = await _getToken();
    if (token == null) {
      return false; // No token means not authenticated
    }

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/todos/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(todo),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Update Todo failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error in updateTodo: $e');
      return false;
    }
  }

  // Delete Todo
  Future<bool> deleteTodo(int userId) async {
    final token = await _getToken();
    if (token == null) {
      return false; // No token means not authenticated
    }

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/todos/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Delete Todo failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error in deleteTodo: $e');
      return false;
    }
  }

  // Get Token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
