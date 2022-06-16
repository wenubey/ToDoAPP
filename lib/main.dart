import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_example/provider/todo_provider.dart';
import 'package:sqflite_example/screens/show_todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ToDoProvider(),
        ),
      ],
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ShowTodoScreen(),
      ),
    );
  }
}
