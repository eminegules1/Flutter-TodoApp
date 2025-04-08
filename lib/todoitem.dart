import 'package:flutter/material.dart';
import 'package:flutter_application_todoapp/constants/tasktype.dart';
import 'package:flutter_application_todoapp/model/task.dart';

class TodoItem extends StatefulWidget {
  const TodoItem(
      {super.key, required this.task, required this.onToggleCompletion});

  final Task task;
  final void Function(Task task) onToggleCompletion;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.task.isCompleted ? Colors.grey.shade200 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: widget.task.type == TaskType.note
                  ? Image.asset("lib/assets/images/Category_1.png", width: 50)
                  : widget.task.type == TaskType.calendar
                      ? Image.asset("lib/assets/images/Category_2.png",
                          width: 50)
                      : Image.asset("lib/assets/images/Category_3.png",
                          width: 50),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.task.description,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 8),
                  if (widget.task.date.isNotEmpty)
                    Text('Date: ${widget.task.date}',
                        style: const TextStyle(
                            fontSize: 13, color: Color.fromARGB(115, 2, 2, 2))),
                  if (widget.task.time.isNotEmpty)
                    Text('Time: ${widget.task.time}',
                        style: const TextStyle(
                            fontSize: 13, color: Color.fromARGB(115, 0, 0, 0))),
                ],
              ),
            ),
            Checkbox(
              value: widget.task.isCompleted,
              onChanged: (val) {
                setState(() {
                  widget.task.isCompleted = val!;
                });
                widget.onToggleCompletion(widget.task);
              },
            ),
          ],
        ),
      ),
    );
  }
}
