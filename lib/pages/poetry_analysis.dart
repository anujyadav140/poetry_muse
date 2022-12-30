import 'dart:convert';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:poetry_muse/api/api.dart';

class Result extends StatefulWidget {
  List<String> lines;
  Result({super.key, required this.lines});
  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  void initState() {
    calculateTotalSyllables();
    findMetre();
    super.initState();
  }

  String syllWord = "";

  late int syllableCounter = 0;

  late List<int> syllableList = [];

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
    } else {
      return 0;
    }
  }

  calculateTotalSyllables() {
    for (var l in widget.lines) {
      setState(() {
        syllableList.add(countSyllables(l));
      });
    }
    print(syllableList);
  }

  late var data;
  late String url;
  late List<String> meter = [];
  void findMetre() async {
    for (var i = 0; i < widget.lines.length; i++) {
      url = 'http://127.0.0.1:5000/meter?lines=${widget.lines[i]}';
      data = await getMetre(url);
      var decodedData = jsonDecode(data);
      setState(() {
        meter.add(decodedData['meter']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        height: 700,
        child: Card(
            color: Colors.amber[50],
            child: FutureBuilder(
                future: getMetre(url),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: widget.lines.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              widget.lines[index],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              meter[index],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
      ),
    );
  }
}
