import 'package:flutter/material.dart';
// import 'package:todo_app/isolate_page.dart';
import 'package:todo_app/stream_page.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StreamPage(),
    // home: IsolatePage(),
    );
  }
}
