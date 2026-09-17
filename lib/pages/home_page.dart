import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';
import 'login_page.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  CollectionReference get tasksCollection {
    final user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('tasks');
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

 
  Future<void> deleteTask(Task task) async {
    if (task.id != null) {
      await tasksCollection.doc(task.id).delete();
    }
  }


  Future<void> toggleTask(Task task) async {
    if (task.id != null) {
      await tasksCollection.doc(task.id).update({
        'isCompleted': !task.isCompleted,
      });
    }
  }

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


  Future<void> addTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    );

    if (result != null) {
      await tasksCollection.add({
        'title': result['title'],
        'description': result['description'],
        'isCompleted': false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
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

         
          final taskDocuments = snapshot.data!.docs;

          final totalTasks = taskDocuments.length;

          final completedTasks = taskDocuments.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['isCompleted'] == true;
          }).length;

          final pendingTasks = totalTasks - completedTasks;

          final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

       
          if (taskDocuments.isEmpty) {
            return const Center(
              child: Text(
                'No tasks yet\nAdd a task to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

         
          return Column(
            children: [
           
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 217, 232, 240),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    
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
                              Color.fromARGB(255, 5, 15, 36),
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

             
             Expanded(
  child: GridView.builder(
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, 
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.75,
    ),
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 6, 20, 36),
        foregroundColor: Colors.white,
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
