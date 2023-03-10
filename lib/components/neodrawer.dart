import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NeoLineContainer extends StatefulWidget {
  const NeoLineContainer({
    super.key,
    this.selected = false,
    required this.line,
    required this.toEdit,
    this.needNewLine = false,
    required this.syllables,
    required this.newLine,
    required this.toFindSyllables,
    required this.metre,
    required this.toFindMetre,
  });

  final bool selected;
  final bool toEdit;
  final bool newLine;
  final bool toFindSyllables;
  final bool toFindMetre;
  final String line;
  final bool needNewLine;
  final int? syllables;
  final String metre;
  @override
  State<NeoLineContainer> createState() => _NeoLineContainerState();
}

class _NeoLineContainerState extends State<NeoLineContainer> {
  late double targetValue = 0.0;
  late int syllable;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selected) {
      targetValue = 50.0;
    }
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Padding(
          padding: widget.selected
              ? const EdgeInsets.only(
                  top: 10,
                  bottom: 40,
                )
              : const EdgeInsets.only(top: 0),
        ),
        Transform.scale(
          scale: widget.toEdit ? 0.99 : 1,
          child: Column(
            children: [
              widget.toEdit && widget.toFindMetre
                  ? AutoSizeText(widget.metre)
                  : const SizedBox(),
              Container(
                width: width,
                height: widget.needNewLine ? 100.0 : 50.0,
                decoration: BoxDecoration(
                  color: widget.toEdit
                      ? Colors.grey[200]
                      : widget.selected
                          ? Colors.grey[200]
                          : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: widget.selected
                      ? null
                      : const [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(3, 3),
                            blurRadius: 5,
                            spreadRadius: -1,
                          ),
                        ],
                ),
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.line.isNotEmpty
                        ? SizedBox(
                            width: width - 60,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 10.0),
                              child: AutoSizeText(
                                // widget.toEdit && widget.toFindSyllables
                                // ? widget.line + widget.syllables.toString()
                                widget.line,
                                style: const TextStyle(fontSize: 20),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 12,
                                maxFontSize: 20,
                              ),
                            ),
                          )
                        : const AutoSizeText(
                            "",
                            style: TextStyle(fontSize: 25),
                          ),
                    widget.toEdit
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              // width: 40,
                              margin: const EdgeInsets.only(right: 10),
                              color: Colors.yellow,
                              child: Visibility(
                                visible: widget.toFindSyllables,
                                child: Text(
                                  widget.syllables.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

bool syllableAlreadyCalculated = false;
String syllWord = "";
int syllableCounter = 0;
List<int> syllableList = [0];
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
