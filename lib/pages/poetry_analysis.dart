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
    findForm();
    super.initState();
  }

  List<String> combined = [];

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

    String combineLines(List<String> lines) {
      return lines.join('\n');
    }
  }

  bool toggleAnalysis = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 700,
      child: Card(
          color: Colors.amber[50],
          child: FutureBuilder(
              future: toggleAnalysis ? postForm(url, data) : getMetre(url),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    meter.length == widget.lines.length) {
                  return Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          toggleAnalysis ? 'Poem Results' : 'Poetry Analysis',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              toggleAnalysis = !toggleAnalysis;
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    toggleAnalysis
                        ? Expanded(
                            child: Column(
                              children: [
                                Text(
                                    "Closest metre: ${formData["Closest metre"]}"),
                                Text(
                                    "Closest rhyme: ${formData["Closest rhyme"]}"),
                                Text(
                                    "Closest rhyme scheme: ${formData["Rhyme scheme"]}"),
                                Text(
                                    "Closest stanza type: ${formData["Closest stanza type"]}"),
                                Text(
                                    "Closest stanza length: ${formData["Stanza lengths"]}"),
                              ],
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: widget.lines.length - 1,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                      title: Text(
                                        widget.lines[index],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        meter[index],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                        syllableList[index].toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ));
                                }),
                          ),
                  ]);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }

  Map<String, String> formData = {};
  void findForm() async {
    url = 'http://127.0.0.1:5000/analysis';
    data = await postForm(url, jsonEncode(widget.lines));
    var decodeData = jsonDecode(data);
    setState(() {
      var form = decodeData['form'];
      print(form);
      form.forEach((key, value) {
        formData[key] = value;
      });
    });
  }
}
