import 'dart:async';
import 'package:flutter/material.dart';

class PoemAnalysisDrawer extends StatefulWidget {
  const PoemAnalysisDrawer({
    super.key,
    required this.drawerColor,
    required this.listPrimaryColor,
    required this.listSecondaryColor,
    required this.drawerHeight,
    required this.listHeight,
    required this.childWidget,
    required this.index,
  });
  final Color? drawerColor;
  final double drawerHeight;
  final double listHeight;
  final Color? listPrimaryColor;
  final Color? listSecondaryColor;
  final Widget childWidget;
  final int index;
  @override
  State<PoemAnalysisDrawer> createState() => _PoemAnalysisDrawerState();
}

class _PoemAnalysisDrawerState extends State<PoemAnalysisDrawer>
    with SingleTickerProviderStateMixin {
  late bool _isDrawed = false;
  double targetValue = 0.0;

  late double _scale;
  late AnimationController _controller;

  int valueIndex = -1;
  void _animate() {
    setState(() {
      _isDrawed = !_isDrawed;
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.015,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Timer(const Duration(milliseconds: 200), () {
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

  void _tapDown(TapDownDetails down) {
    _animate();
    setState(() {
      targetValue = targetValue == 0.0 ? widget.listHeight : 0.0;
    });
    valueIndex = widget.index;
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: _tapDown,
      child: Stack(
        children: [
          TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: targetValue),
              duration: const Duration(milliseconds: 500),
              curve: Curves.bounceOut,
              builder: (_, double value, __) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: Padding(
                    padding: _isDrawed
                        ? const EdgeInsets.only(
                            top: 10,
                          )
                        : const EdgeInsets.only(top: 0),
                    child: Transform.scale(
                      scale: _scale,
                      child: Container(
                        padding: _isDrawed
                            ? const EdgeInsets.only(top: 10)
                            : const EdgeInsets.only(top: 0),
                        width: MediaQuery.of(context).size.width,
                        height:
                            _isDrawed ? widget.drawerHeight : widget.listHeight,
                        decoration: BoxDecoration(
                          color: widget.drawerColor,
                          border: Border.all(color: Colors.black, width: 2.5),
                        ),
                        child: widget.childWidget,
                      ),
                    ),
                  ),
                );
              }),
          Transform.scale(
            scale: _scale,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.listHeight,
              decoration: BoxDecoration(
                color: _isDrawed
                    ? widget.listSecondaryColor
                    : widget.listPrimaryColor,
                border: Border.all(color: Colors.black, width: 2.5),
                boxShadow: _isDrawed
                    ? null
                    : const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(3.5, 3.5),
                          blurRadius: 0,
                          spreadRadius: -1,
                        ),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
