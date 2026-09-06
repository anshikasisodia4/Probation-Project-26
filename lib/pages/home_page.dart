import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/task_card.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> tasks = [];

  // Add task
  void addTask(String title, String description) {
    setState(() {
      tasks.add(Task(title: title, description: description));
    });
  }

  // Delete task
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // Complete or pending
  void toggleTask(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  // Edit task
  void editTask(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskPage(task: tasks[index])),
    );

    if (result != null) {
      setState(() {
        tasks[index].title = result['title'];
        tasks[index].description = result['description'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // View tasks
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks yet\nAdd a task to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  task: tasks[index],
                  onDelete: () => deleteTask(index),
                  onToggle: () => toggleTask(index),
                  onEdit: () => editTask(index),
                );
              },
            ),

      // Add task
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );

          if (result != null) {
            addTask(result['title'], result['description']);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
