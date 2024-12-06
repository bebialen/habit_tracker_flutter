import 'package:flutter/material.dart';
import 'package:habit_tracker/homepage/homepage.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Habit Tracker'),
    );
  }
}
