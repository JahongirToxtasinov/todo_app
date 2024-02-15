import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IsolatePage extends StatefulWidget {
  const IsolatePage({super.key});

  @override
  State<IsolatePage> createState() => _IsolatePageState();
}

class _IsolatePageState extends State<IsolatePage> {
  @override
  Widget build(BuildContext context) {
    int? factorial;
    bool isLoading = false;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          isLoading = true;
          setState(() {});
          await Future.delayed(const Duration(seconds: 1));
          factorial = Random().nextInt(30);
          isLoading = false;
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(builder: (context) {
        if(isLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else {
          if (factorial == null) {
            return const Center(child: Text("Number not selected"));
          } else {
            return Center(
              child: Text('Factorial number $factorial, result - '),
            );
          }
        }
      }),
    );
  }
}
