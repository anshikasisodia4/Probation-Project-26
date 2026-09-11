import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';
import '../widgets/task_card.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firebase Firestore reference
  final CollectionReference tasksCollection = FirebaseFirestore.instance
      .collection('tasks');

  // Add task
  Future<void> addTask(String title, String description) async{
     await tasksCollection.add({
      'title': title,
      'description': description,
      'isCompleted': false,
    });
  }

  // Delete task
  Future<void> deleteTask(Task task) async{
    if (task.id != null) {
      await tasksCollection.doc(task.id).delete();
    }
  }

  // Complete or pending
  Future<void> toggleTask(Task task) async{
     if (task.id != null) {
      await tasksCollection.doc(task.id).update({
        'isCompleted': !task.isCompleted,
      });
    }
  }

  // Edit task
  Future<void> editTask(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskPage(task:task)),
    );

    if (result != null && task.id!=null) {
       await tasksCollection.doc(task.id).update({
        'title': result['title'],
        'description': result['description'],
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

     
      body: StreamBuilder<QuerySnapshot>(
        stream: tasksCollection.snapshots(),
        builder: (context, snapshot) {

          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          // Get tasks from Firebase
          final taskDocuments = snapshot.data!.docs;

          // No tasks
          if (taskDocuments.isEmpty) {
            return const Center(
              child: Text(
                'No tasks yet\nAdd a task to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          }

          // Display tasks
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: taskDocuments.length,
            itemBuilder: (context, index) {

              final document = taskDocuments[index];

              final task = Task.fromMap(
                document.id,
                document.data() as Map<String, dynamic>,
              );

              return TaskCard(
                task: task,

                onDelete: () => deleteTask(task),

                onToggle: () => toggleTask(task),

                onEdit: () => editTask(task),
              );
            },
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
