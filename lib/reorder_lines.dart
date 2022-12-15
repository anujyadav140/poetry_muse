import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ReorderLines extends StatefulWidget {
  const ReorderLines({
    super.key,
    required this.reorderLines,
  });
  final List<String> reorderLines;

  @override
  State<ReorderLines> createState() => _ReorderLinesState();
}

class _ReorderLinesState extends State<ReorderLines>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  bool isReorder = false;
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
          Timer(const Duration(seconds: 1), () {
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

  void _tapDown(TapDownDetails down) {
    _controller.forward();
  }

  //re order lines of poetry i.e reorder tiles
  void reOrderLines(int oldLine, int newLine) {
    if (oldLine >= widget.reorderLines.length) return;
    setState(() {
      if (oldLine < newLine) {
        newLine -= 1;
      }
      final String line = widget.reorderLines.removeAt(oldLine);

      widget.reorderLines.insert(newLine, line);
    });
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: _tapDown,
      onTap: () {
        _controller.reverse();
      },
      child: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          reOrderLines(oldIndex, newIndex);
          setState(() {
            isReorder = false;
          });
        },
        onReorderStart: (int index) {
          // Set the `isReorder` and `selected` variables to true and update the state
          setState(() {
            isReorder = true;
            _controller.reverse();
          });
        },
        children: [
          for (int i = 0; i < widget.reorderLines.length; i++)
            Padding(
              key: Key("lines_$i"),
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                color: Colors.white,
                child: ListTile(
                  title: Transform.scale(
                    scale: _scale,
                    child: AutoSizeText(
                      widget.reorderLines[i],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
