import 'dart:async';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NeoBrutton extends StatefulWidget {
  NeoBrutton({super.key, required this.onPress});
  late VoidCallback onPress;

  @override
  State<NeoBrutton> createState() => _NeoBruttonState();
}

class _NeoBruttonState extends State<NeoBrutton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.15,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Timer(const Duration(milliseconds: 200), () {
            // reset the animation when the AnimationStatus.completed status is reached
            _controller.reset();
          });
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return SizedBox(
      height: 50,
      width: 50,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Transform.scale(
          scale: _scale,
          child: Container(
            // height: 50,
            // width: 50,
            decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(3.5, 3.5),
                blurRadius: 0,
                spreadRadius: -1,
              ),
            ]),
            child: OutlinedButton(
              onPressed: () {
                _controller.forward();
                widget.onPress();
              },
              style: const ButtonStyle(
                side: MaterialStatePropertyAll(BorderSide(width: 2.5)),
                padding: MaterialStatePropertyAll(EdgeInsets.all(20.0)),
                backgroundColor: MaterialStatePropertyAll(Colors.white),
                shape: MaterialStatePropertyAll(CircleBorder()),
              ),
              child: const Icon(
                Icons.view_carousel_outlined,
                size: 70,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
