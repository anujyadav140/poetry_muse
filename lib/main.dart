import 'package:flutter/material.dart';
import 'package:poetry_muse/poetry_muse.dart';

void main() async {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Poetry Muse",
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.blue[200],
          secondary: Colors.pinkAccent,
        )),
        home: const SafeArea(child: PoetryMuse())),
  );
}
