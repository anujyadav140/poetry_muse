import 'package:flutter/material.dart';

class PoetryCard extends StatelessWidget {
  const PoetryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      width: MediaQuery.of(context).size.width * 0.30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(3.5, 3.5),
            blurRadius: 0,
            spreadRadius: -1,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        color: Colors.yellowAccent,
      ),
    );
  }
}
