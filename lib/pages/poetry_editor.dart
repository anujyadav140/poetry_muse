import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:poetry_muse/api/api.dart';
import 'package:poetry_muse/components/neobrutton.dart';
import 'package:poetry_muse/components/neodrawer.dart';
import 'package:poetry_muse/components/neoiconbutton.dart';
import 'package:poetry_muse/components/neotextfield.dart';
import 'package:poetry_muse/components/rive_display.dart';
import 'package:poetry_muse/pages/poetry_analysis.dart';
import 'package:rive/rive.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:english_words/english_words.dart';

//403E3E
//55
class PoetryEditor extends StatefulWidget {
  const PoetryEditor({super.key});

  @override
  State<PoetryEditor> createState() => _PoetryEditorState();
}

class _PoetryEditorState extends State<PoetryEditor>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final DraggableScrollableController _dragController =
      DraggableScrollableController();
  final List<int> _linesTracker = [-1];

  final List<String> _line = [""];

  final _myListKey = GlobalKey<AnimatedListState>();

  double targetValue = 0.0;

  int? _selectedItem, _selectForEdit;

  final TextEditingController _textController = TextEditingController();

  int indexTracker = 0;

  late int _nextItem;

  int statusIndex = 0;
  int newLineIndex = 0;

  bool _anotherLine = false;

  late String url;

  // ignore: prefer_typing_uninitialized_variables
  late var data;

  late List<String> meter = [""];
  late int _meterIndex = -1;
  List<String> word = [""];

  late AnimationController _controller;
  late StateMachineController? _riveController;
  SMIInput<bool>? isClicked;

  final circularMenu = CircularMenu(items: [
    CircularMenuItem(
        icon: Icons.home,
        onTap: () {
          // callback
        }),
    CircularMenuItem(
        icon: Icons.search,
        onTap: () {
          //callback
        }),
    CircularMenuItem(
        icon: Icons.settings,
        onTap: () {
          //callback
        }),
    CircularMenuItem(
        icon: Icons.star,
        onTap: () {
          //callback
        }),
    CircularMenuItem(
        icon: Icons.pages,
        onTap: () {
          //callback
        }),
  ]);

  bool isReorder = false;

  bool isNewLineEdit = false;

  bool isOldLineEdit = false;

  bool syllableAlreadyCalculated = false;

  bool result = false;

  bool startToWrite = false;

  bool toFindSyllables = false;

  bool toFindMetre = false;

  String metre = "";
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
    _nextItem = 1;
    startToWrite = false;
    super.initState();
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

  // ignore: unused_element
  void _remove(int index) {
    setState(() {
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

  void findMetre() async {
    data = await getMetre(url);
    var decodedData = jsonDecode(data);
    setState(() {
      meter.add(decodedData['meter']);
      metre = decodedData['meter'].toString();
    });
    print(metre);
    // displayMetre();
  }

  String syllWord = "";
  String metreWord = "";
  late int syllableCounter = 0;
  late List<int> syllableList = [0];
  int syllableIndex = 0;
  countSyllables(String value) {
    if (value.trim().isNotEmpty) {
      syllWord = value;
      const passwordSpecialCharacters = r'[^\w\s]';
      const whiteSpace = r'\s+';

      syllWord = syllWord.replaceAll(RegExp(passwordSpecialCharacters), '');

      syllWord = syllWord.replaceAll(RegExp(whiteSpace), '');
      syllableCounter = syllables(syllWord);
      return syllableCounter;
    }
  }

  calculateTotalSyllables() {
    if (!syllableAlreadyCalculated) {
      for (var i = 0; i < _line.length - 1; i++) {
        syllableList.add(countSyllables(_line[i].toString()));
      }
    }
    print(syllableList);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var focusNode = FocusNode();
    var counter = 0;
    return Scaffold(
      // floatingActionButton: circularMenu,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      appBar: AppBar(
        title: AutoSizeText(
          "Poem Title ...",
          style: GoogleFonts.farro(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        // shape: const Border(
        //   bottom: BorderSide(
        //     color: Colors.black,
        //     width: 5,
        //   ),
        // ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        leading: GestureDetector(
          onTap: () {
            if (isClicked == null) return;
            final isClick = isClicked?.value ?? false;
            isClicked?.change(!isClick);
          },
          child: SizedBox(
            width: 200,
            height: 200,
            child: DisplayRive(
              rive: RiveAnimation.asset(
                'assets/simple_menu.riv',
                fit: BoxFit.fill,
                antialiasing: false,
                stateMachines: const ['State Machine 1'],
                onInit: (artboard) {
                  _riveController = StateMachineController.fromArtboard(
                      artboard, "State Machine 1");
                  if (_riveController == null) return;
                  artboard.addController(_riveController!);
                  isClicked = _riveController?.findInput<bool>("Hover/Press");
                },
              ),
              riveHeight: 100,
              riveWidth: 100,
            ),
          ),
        ),
        actions: [
          NeoIconButton(
            iconButton: Icon(
              Icons.ac_unit,
              color: _line.first == "" ? Colors.grey : Colors.black,
              size: 25,
            ),
            iconFunction: () {
              setState(() {
                toFindMetre = !toFindMetre;
                metreWord = _line[indexTracker];
                url = 'http://127.0.0.1:5000/meter?lines=$metreWord';
                findMetre();
              });
            },
          ),
          NeoIconButton(
            iconButton: Icon(
              Icons.account_tree,
              color: _line.first == "" ? Colors.grey : Colors.black,
              size: 25,
            ),
            iconFunction: () {},
          ),
          NeoIconButton(
            iconButton: Icon(
              Icons.add_box_rounded,
              color: _line.first == "" ? Colors.grey : Colors.black,
              size: 25,
            ),
            iconFunction: () {
              setState(() {
                toFindSyllables = !toFindSyllables;
                calculateTotalSyllables();
                syllableAlreadyCalculated = true;
              });
            },
          ),
          NeoIconButton(
            iconButton: Icon(
              Icons.abc,
              color: _line.first == "" ? Colors.grey : Colors.black,
              size: 25,
            ),
            iconFunction: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return DraggableScrollableSheet(
                    controller: _dragController,
                    builder: (context, scrollController) {
                      return SingleChildScrollView(
                          controller: scrollController,
                          child: Result(
                            lines: _line,
                          ));
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          //FOR THE ROBOT!
          // Center(
          //   child: SizedBox(
          //     height: height * 0.75,
          //     width: width,
          //     child: const RiveAnimation.asset(
          //       'assets/empty-robot.riv',
          //       fit: BoxFit.contain,
          //       antialiasing: false,
          //       alignment: Alignment.center,
          //       stateMachines: ['Emptiness'],
          //     ),
          //   ),
          // ),
          Visibility(
            visible: !startToWrite,
            child: Positioned(
              left: width * 0.1,
              top: height * 0.07,
              child: Row(
                children: [
                  SizedBox(
                    height: height * 0.15,
                    width: width * 0.15,
                    child: FittedBox(
                        fit: BoxFit.contain, child: Lottie.asset("arrow.json")),
                  ),
                  SizedBox(
                    height: height * 0.2,
                    width: width * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child:
                          AnimatedTextKit(repeatForever: true, animatedTexts: [
                        TypewriterAnimatedText(
                          'Click on it!',
                          textStyle: GoogleFonts.farro(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                          speed: const Duration(milliseconds: 100),
                        ),
                        TypewriterAnimatedText(
                          'Write your poetry here',
                          textStyle: GoogleFonts.farro(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Visibility(
          //   visible: result,
          //   child: Center(
          //     child: SizedBox(
          //       child: Result(lines: _line),
          //     ),
          //   ),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AnimatedList(
                  key: _myListKey,
                  // controller: _scrollController,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  initialItemCount: _linesTracker.length,
                  itemBuilder: (context, index, animation) {
                    newLineIndex = index;
                    return SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  startToWrite = true;
                                });
                                setState(() {
                                  isOldLineEdit = true;
                                  isNewLineEdit = false;
                                  statusIndex = index;
                                  _selectForEdit =
                                      _selectForEdit == _linesTracker[index]
                                          ? null
                                          : _linesTracker[index];
                                });
                                setState(() {
                                  _textController.text = _line[index];
                                  _textController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(offset: _line[index].length),
                                  );
                                });
                                _anotherLine = false;
                                setState(() {
                                  if (_line[index].isEmpty) {
                                    syllableCounter = 0;
                                  } else {
                                    syllableCounter =
                                        countSyllables(_line[index]);
                                  }
                                });
                                setState(() {
                                  if (toFindMetre) {
                                    metreWord = _line[index];
                                    url =
                                        'http://127.0.0.1:5000/meter?lines=$metreWord';
                                    findMetre();
                                  }
                                });
                              },
                              child: NeoLineContainer(
                                syllables: syllableCounter,
                                toFindSyllables: toFindSyllables,
                                toFindMetre: toFindMetre,
                                selected: _selectedItem == _linesTracker[index],
                                // onTap: () {
                                //   // _selectedItem = _linesTracker[index];
                                //   // _remove(index);
                                //   setState(() {
                                //     _selectedItem =
                                //         _selectedItem == _linesTracker[index]
                                //             ? null
                                //             : _linesTracker[index];
                                //   });
                                // },
                                line: _line[index],
                                toEdit: _selectForEdit == _linesTracker[index],
                                needNewLine:
                                    _selectForEdit == _linesTracker[index]
                                        ? _anotherLine
                                        : false,
                                newLine: _selectForEdit == newLineIndex++,
                                metre: metre,
                              ),
                            ),
                          ),
                          // Visibility(
                          //   visible: true,
                          //   child: SizedBox(
                          //     child: Text("Syllable Count: $syllableCounter"),
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RawKeyboardListener(
                    focusNode: focusNode,
                    onKey: (event) {
                      if (event.isKeyPressed(LogicalKeyboardKey.space) ||
                          event.isKeyPressed(LogicalKeyboardKey.backspace)) {
                        setState(() {
                          countSyllables(syllWord);
                          _textController.text == ""
                              ? syllableCounter = 0
                              : syllableCounter;
                        });
                        setState(() {
                          url = 'http://127.0.0.1:5000/meter?lines=$metreWord';
                          findMetre();
                        });
                      }
                    },
                    child: NeoTextField(
                      textController: _textController,
                      onTextChange: (value) {
                        syllWord = value;
                        metreWord = value;
                        setState(() {
                          isNewLineEdit
                              ? _line[indexTracker] = value
                              : isOldLineEdit
                                  ? _line[statusIndex] = value
                                  : _line[indexTracker] = value;
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
                      onSubmit: (value) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: NeoBrutton(
                      onPress: () {
                        isNewLineEdit = true;
                        isOldLineEdit = false;
                        setState(() {
                          _selectForEdit = newLineIndex++;
                          syllableCounter = 0;
                          metre = "";
                        });
                        circularMenu;
                        _insert();
                        _textController.clear();
                        syllableList = [0];
                        syllableAlreadyCalculated = false;
                        _anotherLine = false;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
