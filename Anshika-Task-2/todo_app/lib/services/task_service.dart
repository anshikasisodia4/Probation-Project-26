import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

class TaskService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  // CREATE
  Future<void> addTask(Task task) async {
    await tasks.add(task.toMap());
  }

  // READ
  Stream<List<Task>> getTasks() {
    return tasks.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  // UPDATE
  Future<void> updateTask(Task task) async {
    if (task.id == null) return;

    await tasks.doc(task.id).update(task.toMap());
  }

  // DELETE
  Future<void> deleteTask(String id) async {
    await tasks.doc(id).delete();
  }
}