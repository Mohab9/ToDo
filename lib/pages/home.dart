import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/task.dart';
import 'package:todo_app/pages/edit_task.dart';
import 'package:todo_app/service/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot>? taskStream;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Future<void> getontheload() async {
    final stream = await DatabaseMethods().getTaskList();
    setState(() {
      taskStream = stream;
    });
  }

  Future<void> deleteTask(String taskId) async {
    await DatabaseMethods().deleteTask(taskId);
  }

  Future<void> updateTaskOrder(List<Map<String, dynamic>> tasks) async {
    await DatabaseMethods().updateTaskOrder(tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Your ',
              style: TextStyle(
                color: Colors.red,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Tasks',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: taskStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No tasks available'));
          }

          List<DocumentSnapshot> tasks = snapshot.data!.docs;

          return ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            onReorder: (oldIndex, newIndex) async {
              // Adjust newIndex to account for the removed item
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }

              // Reorder tasks
              final reorderedTasks = <Map<String, dynamic>>[];
              for (int i = 0; i < tasks.length; i++) {
                reorderedTasks.add({
                  'id': tasks[i].id,
                  // Include other fields if necessary
                });
              }
              final movedTask = reorderedTasks.removeAt(oldIndex);
              reorderedTasks.insert(newIndex, movedTask);

              // Update the order in Firestore
              await updateTaskOrder(reorderedTasks);
            },
            children: tasks.map((taskDoc) {
              return Dismissible(
                key: Key(taskDoc.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  deleteTask(taskDoc.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task deleted')),
                  );
                },
                child: MouseRegion(
                  onEnter: (_) => setState(() {
                    _hoveredIndex = tasks.indexOf(taskDoc);
                  }),
                  onExit: (_) => setState(() {
                    _hoveredIndex = null;
                  }),
                  child: AnimatedContainer(
                    key: ValueKey(taskDoc.id), // Key for reordering
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()..scale(_hoveredIndex == tasks.indexOf(taskDoc) ? 1.03 : 1.0),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.red],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Title: ${taskDoc['title']}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => EditTaskDialog(
                                        id: taskDoc.id,
                                        currentTitle: taskDoc['title'],
                                        currentDescription: taskDoc['description'],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueAccent,
                                          blurRadius: 4,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Description: ${taskDoc['description']}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Task()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
