import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poetry_muse/components/neobrutton.dart';

class NeoCard extends StatelessWidget {
  const NeoCard(
      {super.key,
      required this.height,
      required this.width,
      required this.title,
      required this.subTitle});
  final double height;
  final double width;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2.5, color: Colors.black),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(3.5, 3.5),
                  blurRadius: 0,
                  spreadRadius: -1,
                )
              ],
            ),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      title,
                      style: GoogleFonts.farro(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(subTitle,
                        style: GoogleFonts.farro(
                          color: Colors.black,
                        )),
                    leading: const Icon(Icons.person),
                  ),
                  const Divider(color: Colors.black, thickness: 2.5),
                  Row(
                    children: [
                      NeoBrutton(
                        onPress: () {},
                        isCircle: false,
                        isIcon: false,
                        // buttonName: "Yes.",
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
