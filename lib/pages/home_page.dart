import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  CollectionReference get tasksCollection {
    final user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('tasks');
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Delete task
  Future<void> deleteTask(Task task) async {
    if (task.id != null) {
      await tasksCollection.doc(task.id).delete();
    }
  }

  // Complete or pending
  Future<void> toggleTask(Task task) async {
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
      MaterialPageRoute(builder: (context) => AddTaskPage(task: task)),
    );

    if (result != null && task.id != null) {
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
        title: const Text(' Tasks'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: tasksCollection.snapshots(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          // Get tasks from Firebase
          final taskDocuments = snapshot.data!.docs;
          final totalTasks = taskDocuments.length;

          final completedTasks = taskDocuments.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['isCompleted'] == true;
          }).length;

          final pendingTasks = totalTasks - completedTasks;

          final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

          // No tasks
          if (taskDocuments.isEmpty) {
            return const Center(
              child: Text(
                'No tasks yet\nAdd a task to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Progress + Tasks
          return Column(
            children: [
              // Progress Card
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // Circular Progress
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF90CAF9),
                            ),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 25),

                    // Task Counts
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Task Progress',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            '✓ Completed: $completedTasks',
                            style: const TextStyle(fontSize: 16),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '○ Pending: $pendingTasks',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Existing Task List
              Expanded(
                child: ListView.builder(
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
                ),
              ),
            ],
          );
        },
      ),

      // Add task
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
