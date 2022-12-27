import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FindMeter extends StatelessWidget {
  final String meter;
  const FindMeter({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        WavyAnimatedText(meter),
      ],
      isRepeatingAnimation: false,
      totalRepeatCount: 1,
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }
}
