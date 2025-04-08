import 'package:flutter/material.dart';
import 'package:flutter_application_todoapp/constants/color.dart'; // Assuming a color constant file
import 'package:flutter_application_todoapp/constants/tasktype.dart';
import 'package:flutter_application_todoapp/model/task.dart';
import 'package:flutter_application_todoapp/screens/add_new_task.dart';
import 'package:flutter_application_todoapp/service/auth_service.dart';
import 'package:flutter_application_todoapp/service/todo_service.dart';
import 'package:flutter_application_todoapp/todoitem.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoService todoService = TodoService(); // Instance of TodoService

  List<Task> todo = [
    Task(
      userId: 100,
      type: TaskType.calendar,
      title: "Study Lessons",
      description: "Study COMP-117 lessons",
      date: "2024-08-12",
      time: "14:00",
      isCompleted: false,
    ),
    Task(
      userId: 200,
      type: TaskType.note,
      title: "Run 5K",
      description: "Run 5K for today",
      date: "2024-08-12",
      time: "07:00",
      isCompleted: false,
    ),
    Task(
      userId: 300,
      type: TaskType.contest,
      title: "Go to party",
      description: "Attend to the party",
      date: "2024-08-12",
      time: "19:00",
      isCompleted: false,
    ),
  ];

  List<Task> completed = [];

  // Function to add a new task
  Future<bool> addNewTask(Task newTask) async {
    // Use TodoService to add a new task via API call
    bool result = await todoService.addTask(newTask);

    if (result) {
      setState(() {
        todo.add(newTask); // Add task to the todo list
      });
    }

    return result;
  }

  // Function to toggle task completion
  void toggleTaskCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted; // Toggle the completion status

      if (task.isCompleted) {
        todo.remove(task);
        completed.add(task);
      } else {
        completed.remove(task);
        todo.add(task);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    String currentDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: HexColor(backgroundColor),
          body: Column(
            children: [
              // Header
              Container(
                width: deviceWidth,
                height: deviceHeight / 3,
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  image: DecorationImage(
                    image: AssetImage("lib/assets/images/header (2).png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        currentDate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "My Todo List",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Todo List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: todo.length,
                      itemBuilder: (context, index) {
                        return TodoItem(
                          task: todo[index],
                          onToggleCompletion: toggleTaskCompletion,
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Completed Text
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Completed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              // Completed List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: completed.length,
                      itemBuilder: (context, index) {
                        return TodoItem(
                          task: completed[index],
                          onToggleCompletion: toggleTaskCompletion,
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Add New Task Button
              ElevatedButton(
                onPressed: () async {
                  // Retrieve userId from SharedPreferences
                  AuthService authService = AuthService();
                  int? currentUserId = await authService.getUserId();

                  if (currentUserId != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddNewTaskScreen(
                          addNewTask: (newTask) =>
                              addNewTask(newTask), // Pass the function
                          userId:
                              currentUserId, // Pass the userId to the screen
                        ),
                      ),
                    );
                  } else {
                    print('Error: userId is null. Please log in again.');
                    // You may want to handle the case where userId is null, like redirecting to login screen
                  }
                },
                child: const Text('Add New Task'), // Button text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
