import 'package:flutter/material.dart';
import 'package:todo_app/service/database.dart';

class EditTaskDialog extends StatefulWidget {
  final String id;
  final String currentTitle;
  final String currentDescription;

  const EditTaskDialog({
    required this.id,
    required this.currentTitle,
    required this.currentDescription,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> with SingleTickerProviderStateMixin {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.currentTitle);
    descriptionController = TextEditingController(text: widget.currentDescription);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> updateTask() async {
    String updatedTitle = titleController.text.trim();
    String updatedDescription = descriptionController.text.trim();

    if (updatedTitle.isEmpty || updatedDescription.isEmpty) {
      // Show warning dialog if title or description is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Input Error'),
            content: const Text('Title and description cannot be empty!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    Map<String, dynamic> updatedTaskMap = {
      "title": updatedTitle,
      "description": updatedDescription,
    };

    await DatabaseMethods().updateTaskDetails(widget.id, updatedTaskMap).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Edit Task",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            buildTextField(
              controller: titleController,
              hintText: "Task title",
              shadowColor: Colors.blue.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            buildTextField(
              controller: descriptionController,
              hintText: "Task description",
              maxLines: 4,
              shadowColor: Colors.red.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                updateTask();
              },
              onTapDown: (_) {
                _animationController.forward();
              },
              onTapUp: (_) {
                _animationController.reverse();
              },
              onTapCancel: () {
                _animationController.reverse();
              },
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Update Task",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    required Color shadowColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[600],
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
