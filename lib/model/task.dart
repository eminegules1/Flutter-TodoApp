import 'package:flutter_application_todoapp/constants/tasktype.dart';
import 'dart:convert';

class Task {
  final int userId;
  final TaskType type; // Use TaskType instead of String
  final String title;
  final String description;
  final String date;
  final String time;
  bool isCompleted;

  Task({
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'type': type.toString().split('.').last, // Convert enum to string
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'isCompleted': isCompleted,
    };
  }
}
