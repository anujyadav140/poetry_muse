import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:poetry_muse/components/neocard.dart';
import 'package:poetry_muse/components/neodrawer.dart';
import 'package:poetry_muse/components/neotextfield.dart';
import 'package:poetry_muse/drawer.dart';
import 'package:poetry_muse/components/neobrutton.dart';
import 'package:poetry_muse/pages/poetry_editor.dart';
import 'package:poetry_muse/reorder_lines.dart';
import 'package:english_words/english_words.dart';
import 'package:poetry_muse/swipe_card.dart';

class PoetryMuse extends StatefulWidget {
  const PoetryMuse({super.key});

  @override
  State<PoetryMuse> createState() => _PoetryMuseState();
}

class _PoetryMuseState extends State<PoetryMuse> {
  final List<TextEditingController> _controllers = [TextEditingController()];
  final ScrollController _scrollController = ScrollController();
  final List<String> _lines = [''];
  final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);

  final FocusNode _focusNode = FocusNode(); // Add a focus node

  bool _showCursor = true;

  bool _isFocused = false;

  var isCircular = false;

  bool isNotReorder = true;

  String word = "";

  String language = "";

  int syllableCounter = 0;

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the cursor to blink every half second
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _showCursor = !_showCursor;
      });
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // If the textfield gains focus, scroll to the bottom
        _scrollToBottom();
        setState(() {
          _isFocused = true;
        });
      } else {
        // If the textfield loses focus, remove the listener
        // so that the list view is no longer automatically scrolled
        _scrollController.removeListener(_scrollToBottom);
        setState(() {
          _isFocused = false;
        });
      }
    });
  }

//added condition to check if it is focused or not, if focused then ONLY it scrolls to bottom
  _scrollToBottom() {
    if (_scrollController.hasClients && _isFocused) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //for stopping the app to go to landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //for autoscrolling
    SchedulerBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return const Scaffold(
      backgroundColor: Colors.white,
      // body: PoetryEditor(),
      body: NeoCard(
        height: 200,
        width: 400,
        title: "Do you really want to delete this line ?",
        subTitle: "(you can always undo the changes)",
      ),
      // body: GestureDetector(
      //   onTap: () {
      //     FocusScope.of(context).unfocus();
      //   },
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      // Expanded(
      //   child: isNotReorder
      //       ? ListView.builder(
      //           controller: _scrollController,
      //           shrinkWrap: true,
      //           physics: const AlwaysScrollableScrollPhysics(),
      //           itemCount: _lines.length,
      //           itemBuilder: (BuildContext context, int index) {
      //             return Padding(
      //               padding: const EdgeInsets.only(top: 10, bottom: 10),
      //               child: poemLineTiles(
      //                 lines: _lines,
      //                 showCursor: _showCursor,
      //                 index: index,
      //               ),
      //             );
      //           })
      //       : ReorderLines(
      //           reorderLines: _lines,
      //         ),
      // ),
      // SwipePoetryCard(),
      // const NeoDrawer(),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     NeoTextField(
      //       textController: _textController,
      //     ),
      //     NeoBrutton(onPress: () {}),
      //   ],
      // ),

      // Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     SingleChildScrollView(
      //       scrollDirection: Axis.vertical,
      //       child: Container(
      //         height: 80,
      //         width: size.width * 0.78,
      //         margin:
      //             const EdgeInsets.only(bottom: 3, right: 10, left: 5),
      //         alignment: Alignment.bottomCenter,
      //         child: TextField(
      //           focusNode:
      //               _focusNode, // Set the focus node to the textfield
      //           onChanged: (value) {
      //             setState(() {
      //               try {
      //                 _lines[_lines.length - 1] = value;
      //                 word = value;
      //                 const passwordSpecialCharacters = r'[^\w\s]';
      //                 const whiteSpace = r'\s+';

      //                 word = word.replaceAll(
      //                     RegExp(passwordSpecialCharacters), '');

      //                 word = word.replaceAll(RegExp(whiteSpace), '');

      //                 syllableCounter = syllables(word);
      //                 print(syllableCounter);
      //               } catch (e) {
      //                 if (e is FlutterError) {
      //                   print(e);
      //                 } else {
      //                   print("i dont know wht went wrong");
      //                 }
      //               }
      //             });
      //           },
      //           onSubmitted: (value) async {
      //             if (value.isNotEmpty) {
      //               final String response =
      //                   await languageIdentifier.identifyLanguage(value);
      //               language = response;
      //               setState(() {
      //                 try {
      //                   Fluttertoast.cancel();
      //                   // Update the _lines list
      //                   if (language == "en") {
      //                     _lines[_lines.length - 1] = value;
      //                     _lines.add('');

      //                     // Update the _controllers list to match the _lines list
      //                     _controllers.add(TextEditingController());
      //                     _controllers[0].clear();

      //                     // Request focus on the textfield
      //                     FocusScope.of(context).requestFocus(_focusNode);
      //                   }
      //                 } catch (e) {
      //                   if (e is FlutterError) {
      //                     // Handle the FlutterError
      //                   } else {
      //                     // Handle other types of errors
      //                   }
      //                 }
      //               });
      //             } else if (value.isEmpty) {
      //               Fluttertoast.showToast(
      //                 msg: "Type some words ...",
      //                 toastLength: Toast.LENGTH_SHORT,
      //                 gravity: ToastGravity.CENTER,
      //                 timeInSecForIosWeb: 1,
      //                 backgroundColor: Colors.blueAccent,
      //                 textColor: Colors.white,
      //                 fontSize: 20.0,
      //               );
      //             }
      //           },
      //           textAlign: TextAlign.start,
      //           controller: _controllers[0],
      //           decoration: const InputDecoration(
      //             hintText: "Type away ...",
      //             border: OutlineInputBorder(),
      //             enabledBorder: OutlineInputBorder(
      //               borderSide: BorderSide(color: Colors.green, width: 2),
      //               borderRadius: BorderRadius.only(
      //                 topLeft: Radius.circular(20.0),
      //                 topRight: Radius.circular(20.0),
      //                 bottomLeft: Radius.circular(20.0),
      //                 bottomRight: Radius.circular(20.0),
      //               ),
      //             ),
      //             focusedBorder: OutlineInputBorder(
      //               borderSide: BorderSide(color: Colors.blue, width: 3),
      //               borderRadius: BorderRadius.only(
      //                 topLeft: Radius.circular(20.0),
      //                 topRight: Radius.circular(20.0),
      //                 bottomLeft: Radius.circular(20.0),
      //                 bottomRight: Radius.circular(20.0),
      //               ),
      //             ),
      //           ),
      //           autofocus: false,
      //           keyboardType: TextInputType.text,
      //           cursorColor: Colors.black,
      //           cursorHeight: 25,
      //           cursorRadius: const Radius.circular(12),
      //           cursorWidth: 2,
      //           readOnly: false,
      //           enableSuggestions: true,
      //           autocorrect: true,
      //           maxLines: null, // Set maxLines to null
      //           expands: false,
      //           textCapitalization: TextCapitalization.sentences,
      //           style: const TextStyle(
      //               fontStyle: FontStyle.normal, fontSize: 20),
      //         ),
      //       ),
      //     ),
      //     NeoBrutton(
      //       onPress: () {
      //         setState(() {
      //           isCircular =
      //               !isCircular; // toggle the shape of the button
      //           isNotReorder = !isNotReorder; //re ordering lines
      //         });
      //       },
      //     ),
      //   ],
      // ),
      // ],
      // ),
      // ),
    );
  }
}

// ignore: camel_case_types
class poemLineTiles extends StatelessWidget {
  const poemLineTiles({
    super.key,
    required List<String> lines,
    required bool showCursor,
    required this.index,
  })  : _lines = lines,
        _showCursor = showCursor;

  final List<String> _lines;
  final bool _showCursor;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: PoemAnalysisDrawer(
            index: index,
            drawerColor: Colors.redAccent,
            listPrimaryColor: Colors.blue,
            drawerHeight: 200,
            listHeight: 50.0,
            listSecondaryColor: Colors.blue[900],
            childWidget: AutoSizeText(
              index == _lines.length - 1
                  ? _showCursor
                      ? "${_lines[index]}|"
                      : _lines[index]
                  : _lines[index],
              style: index == _lines.length - 1
                  ? const TextStyle(fontSize: 20, color: Colors.blue)
                  : const TextStyle(fontSize: 20),
              maxLines: 2,
            ),
          ),
          tileColor: Colors.white,
        ),
      ],
    );
  }
}
