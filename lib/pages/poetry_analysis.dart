import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  Result({super.key});
  final List<String> lines = [
    "to be or not to be that is the question",
    "shall i compare thee to a summer's day?",
    "to be or not to be that is the question",
    "shall i compare thee to a summer's day?",
    "to be or not to be that is the question",
    "shall i compare thee to a summer's day?",
    "to be or not to be that is the question",
    "shall i compare thee to a summer's day?",
  ];
  // final List<String> lines;
  void result() {}
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        height: 700,
        child: Card(
          color: Colors.amber[50],
          child: Column(
            children: [
              for (var i in lines)
                SizedBox(
                  height: 50,
                  child: Text(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
