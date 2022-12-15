import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poetry_muse/utilities/card.dart';

// ignore: must_be_immutable
class SwipePoetryCard extends StatelessWidget {
  SwipePoetryCard({super.key});
  List<Container> cards = [
    Container(
      child: const PoetryCard(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.70,
        width: MediaQuery.of(context).size.width * 0.90,
        child: AppinioSwiper(
          cards: cards,
        ),
      ),
    );
  }
}
