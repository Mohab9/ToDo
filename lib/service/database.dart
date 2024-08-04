import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add or update task details
  Future<void> addTaskDetails(Map<String, dynamic> taskMap, String id) async {
    // Get the current highest order value from the existing tasks
    final snapshot = await _firestore.collection("Tasks").orderBy('order', descending: true).limit(1).get();

    int currentMaxOrder = 0;
    if (snapshot.docs.isNotEmpty) {
      currentMaxOrder = snapshot.docs.first['order'];
    }

    // Set the order for the new task
    taskMap['order'] = currentMaxOrder + 1;

    await _firestore.collection("Tasks").doc(id).set(taskMap);
  }

  // Get list of tasks
  Future<Stream<QuerySnapshot>> getTaskList() async {
    // Ensure tasks are ordered by the 'order' field
    return _firestore.collection("Tasks").orderBy('order').snapshots();
  }

  // Update task details
  Future<void> updateTaskDetails(String id, Map<String, dynamic> taskMap) async {
    await _firestore.collection("Tasks").doc(id).update(taskMap);
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection("Tasks").doc(taskId).delete();
  }

  // Update the order of tasks
  Future<void> updateTaskOrder(List<Map<String, dynamic>> tasks) async {
    final batch = _firestore.batch();
    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      batch.update(
        _firestore.collection('Tasks').doc(task['id']),
        {'order': i}, // Ensure each task document has an 'order' field
      );
    }
    await batch.commit();
  }
}
