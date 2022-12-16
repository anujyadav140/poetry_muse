import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class NeoBrutton extends StatefulWidget {
  NeoBrutton({
    super.key,
    required this.onPress,
    this.isCircle = true,
    this.isIcon = true,
    this.buttonName = '',
    this.buttonHeight = 50,
    this.buttonWidth = 50,
  });
  late VoidCallback onPress;
  late bool isCircle;
  late bool isIcon;
  late String buttonName;
  late double buttonHeight;
  late double buttonWidth;

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
      height: widget.buttonHeight,
      width: widget.buttonWidth,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Transform.scale(
          scale: _scale,
          child: Container(
            height: !widget.isCircle
                ? null
                : widget.isIcon
                    ? null
                    : widget.buttonHeight,
            width: !widget.isCircle
                ? widget.buttonWidth
                : widget.isIcon
                    ? null
                    : widget.buttonWidth,
            decoration: BoxDecoration(
                shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
                boxShadow: const [
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
              style: ButtonStyle(
                side: MaterialStatePropertyAll(
                    BorderSide(width: widget.isCircle ? 2.5 : 1.5)),
                padding: const MaterialStatePropertyAll(EdgeInsets.all(20.0)),
                backgroundColor: const MaterialStatePropertyAll(Colors.white),
                shape: MaterialStatePropertyAll(widget.isCircle
                    ? const CircleBorder()
                    : const BeveledRectangleBorder()),
              ),
              child: widget.isIcon
                  ? const Icon(
                      Icons.view_carousel_outlined,
                      size: 70,
                      color: Colors.black,
                    )
                  : Text(
                      widget.buttonName,
                      style: GoogleFonts.farro(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
