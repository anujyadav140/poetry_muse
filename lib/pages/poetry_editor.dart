import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poetry_muse/components/neobrutton.dart';
import 'package:poetry_muse/components/neodrawer.dart';
import 'package:poetry_muse/components/neotextfield.dart';
import 'package:rive/rive.dart';

class PoetryEditor extends StatefulWidget {
  const PoetryEditor({super.key});

  @override
  State<PoetryEditor> createState() => _PoetryEditorState();
}

class _PoetryEditorState extends State<PoetryEditor>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  final List<int> _linesTracker = [0];

  final List<String> _line = [""];

  final _myListKey = GlobalKey<AnimatedListState>();

  double targetValue = 0.0;

  int? _selectedItem, _selectForEdit;

  final TextEditingController _textController = TextEditingController();

  int indexTracker = 0;

  late int _nextItem;

  int statusIndex = 0;

  bool _anotherLine = false;

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
    _nextItem = 1;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _insert() {
    int index = _selectedItem == null
        ? _linesTracker.length
        : _linesTracker.indexOf(_selectedItem!);

    setState(() {
      indexTracker++;
      _linesTracker.insert(index, _nextItem++);
      _line.insert(index, "");
      _myListKey.currentState
          ?.insertItem(index, duration: const Duration(milliseconds: 500));
    });
  }

  void _remove(int index) {
    setState(() {
      print(index);
      int removeIndex = _linesTracker.indexOf(
          _selectedItem!); // Use the selected item to determine the index of the item to remove.
      _line.removeAt(removeIndex);
      _linesTracker.removeAt(removeIndex);
      _selectedItem =
          null; // Update the selected item to null after removing the item from the list.
      _myListKey.currentState?.removeItem(
          removeIndex,
          (context, animation) => FadeTransition(
                  opacity: Tween(begin: 5.0, end: 0.0).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ))));
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var counter = 0;
    return Stack(
      children: [
        Center(
          child: SizedBox(
            height: height * 0.75,
            width: width,
            child: const RiveAnimation.asset(
              'assets/empty-robot.riv',
              fit: BoxFit.contain,
              antialiasing: false,
              alignment: Alignment.center,
              stateMachines: ['Emptiness'],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedList(
              key: _myListKey,
              controller: _scrollController,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              initialItemCount: _linesTracker.length,
              itemBuilder: (context, index, animation) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        statusIndex = index;
                        _selectForEdit = _selectForEdit == _linesTracker[index]
                            ? null
                            : _linesTracker[index];
                      });
                      setState(() {
                        _textController.text = _line[index];
                        _textController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _line[index].length),
                        );
                      });
                      print(index);
                    },
                    child: NeoLineContainer(
                      selected: _selectedItem == _linesTracker[index],
                      onTap: () {
                        // _selectedItem = _linesTracker[index];
                        // _remove(index);
                        setState(() {
                          _selectedItem = _selectedItem == _linesTracker[index]
                              ? null
                              : _linesTracker[index];
                        });
                      },
                      line: _line[index],
                      toEdit: _selectForEdit == _linesTracker[index],
                      needNewLine: _anotherLine,
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                NeoTextField(
                  textController: _textController,
                  onTextChange: (value) {
                    setState(() {
                      _line[statusIndex] = value;
                      counter = value.toString().length;
                      if (counter > 40) {
                        setState(() {
                          _anotherLine = true;
                        });
                      } else if (counter < 40) {
                        setState(() {
                          _anotherLine = false;
                        });
                      }
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: NeoBrutton(
                    onPress: () {
                      _textController.clear();
                      _insert();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
