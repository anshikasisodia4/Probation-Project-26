import 'package:flutter/material.dart';
import '../models/task.dart';

class AddTaskPage extends StatefulWidget {
final Task? task;

const AddTaskPage({
super.key,
this.task,
});

@override
State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
final TextEditingController titleController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();

@override
void initState() {
super.initState();


if (widget.task != null) {
  titleController.text = widget.task!.title;
  descriptionController.text = widget.task!.description;
}


}

@override
void dispose() {
titleController.dispose();
descriptionController.dispose();
super.dispose();
}

void saveTask() {
final title = titleController.text.trim();
final description = descriptionController.text.trim();


// Validation
if (title.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Please enter a task title'),
    ),
  );
  return;
}

Navigator.pop(context, {
  'title': title,
  'description': description,
});


}

@override
Widget build(BuildContext context) {
final isEditing = widget.task != null;


return Scaffold(
  appBar: AppBar(
    title: Text(
      isEditing ? 'Edit Task' : 'Add Task',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  body: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        TextField(
          controller: titleController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Task Title',
            hintText: 'Enter your task',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.task_alt),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText: 'Enter task details (optional)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description_outlined),
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: saveTask,
            child: Text(
              isEditing ? 'Update Task' : 'Add Task',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);


}
}
