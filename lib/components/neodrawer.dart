import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NeoLineContainer extends StatelessWidget {
  NeoLineContainer({
    super.key,
    this.onTap,
    this.selected = false,
    required this.line,
    required this.toEdit,
    this.needNewLine = false,
  });

  final bool selected;
  final bool toEdit;
  final VoidCallback? onTap;
  final String line;
  final bool needNewLine;

  late double targetValue = 0.0;

  @override
  Widget build(BuildContext context) {
    if (selected) {
      targetValue = 50.0;
    }
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return TweenAnimationBuilder(
        duration: const Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0, end: targetValue),
        curve: Curves.bounceOut,
        builder: (_, value, __) {
          return Stack(
            children: [
              Transform.translate(
                offset: Offset(0, value),
                child: Padding(
                  padding: selected
                      ? const EdgeInsets.only(
                          top: 10,
                          bottom: 40,
                        )
                      : const EdgeInsets.only(top: 0),
                  child: Transform.scale(
                    scale: toEdit ? 0.99 : 1,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      height: selected ? 100 : 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2.5),
                      ),
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: toEdit ? 0.99 : 1,
                child: Container(
                  width: _width,
                  height: needNewLine ? 100.0 : 50.0,
                  decoration: BoxDecoration(
                    color: toEdit
                        ? Colors.grey[200]
                        : selected
                            ? Colors.grey[200]
                            : Colors.white,
                    border: Border.all(color: Colors.black, width: 2.5),
                    boxShadow: selected
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
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      line.isNotEmpty
                          ? SizedBox(
                              width: _width - 60,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: AutoSizeText(
                                  line,
                                  style: const TextStyle(fontSize: 20),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 12,
                                  maxFontSize: 20,
                                ),
                              ),
                            )
                          : const AutoSizeText(
                              " >>",
                              style: TextStyle(fontSize: 25),
                            ),
                      GestureDetector(
                        onTap: onTap,
                        child: const Center(
                            child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.arrow_downward_outlined),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
