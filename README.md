ToDo App
Overview
The ToDo App is a task management application built with Flutter and Firebase. It provides users with the ability to create, update, and delete tasks through a user-friendly interface.

Features
Task Management: Add new tasks, edit existing ones, and delete tasks.
Reorder Tasks: Easily reorder tasks by dragging and dropping them.
Swipe-to-Delete: Swipe tasks to remove them from the list.
Animated UI: Enjoy smooth animations for task cards and buttons.
Technologies Used
Flutter: Framework for building the user interface.
Firebase: Backend services including Firestore for data storage.
Cloud Firestore: Database for storing task details.
Code Structure
lib/main.dart: Entry point of the app, initializes Firebase and sets up the main app widget.
lib/pages/home.dart: Displays the list of tasks, allows reordering and deleting tasks.
lib/pages/task.dart: Screen for adding a new task.
lib/pages/edit_task.dart: Dialog for editing an existing task.
lib/service/database.dart: Contains methods for interacting with Firestore.
Usage
Adding a Task
Navigate to the Add Task screen, enter the task title and description, and tap "Add Task" to save.

Editing a Task
Tap the edit icon on a task card to open the edit dialog, update the task details, and save the changes.

Deleting a Task
Swipe a task card to delete it or use the delete icon on the task card.

Reordering Tasks
Drag and drop tasks in the list to reorder them.

APK
You can download the APK from the following link: Download APK
