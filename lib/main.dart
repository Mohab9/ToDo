import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDZ51gy0-quMcvDU4Q81PIrxpfehDD9CwY",
        authDomain: "todo-ff621.firebaseapp.com",
        projectId: "todo-ff621",
        storageBucket: "todo-ff621.appspot.com",
        messagingSenderId: "896952163405",
        appId: "1:896952163405:web:e8f444b71b7113566dd004",
        measurementId: "G-12NQTE9D5F",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
