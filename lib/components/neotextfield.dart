import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class NeoTextField extends StatelessWidget {
  NeoTextField({
    super.key,
    required this.textController,
    required this.onTextChange,
    required this.onSubmit,
  });

  late TextEditingController textController = TextEditingController();
  late Function onTextChange;
  late Function onSubmit;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.82;
    return Container(
      height: 100,
      width: width,
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Write a line ... ',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.5),
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.go,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]'),
                      replacementString: ' '),
                ],
                maxLines: null,
                onChanged: (value) {
                  onTextChange(value);
                },
                onSubmitted: (value) {
                  onSubmit(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
