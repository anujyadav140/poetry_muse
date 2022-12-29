import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poetry_muse/components/rive_display.dart';
import 'package:rive/rive.dart';

// ignore: must_be_immutable
class NeoBrutton extends StatefulWidget {
  NeoBrutton({
    super.key,
    required this.onPress,
    this.isCircle = true,
    this.isIcon = true,
    this.buttonName = '',
    this.buttonHeight = 50,
    this.buttonWidth = 50,
  });
  late VoidCallback onPress;
  late bool isCircle;
  late bool isIcon;
  late String buttonName;
  late double buttonHeight;
  late double buttonWidth;
  @override
  State<NeoBrutton> createState() => _NeoBruttonState();
}

class _NeoBruttonState extends State<NeoBrutton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  StateMachineController? _riveController;

  SMIInput<bool>? isClicked;

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
          Timer(const Duration(milliseconds: 200), () {
            // reset the animation when the AnimationStatus.completed status is reached
            _controller.reset();
          });
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return SizedBox(
      height: widget.buttonHeight,
      width: widget.buttonWidth,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Transform.scale(
          scale: _scale,
          child: Container(
            height: !widget.isCircle
                ? null
                : widget.isIcon
                    ? null
                    : widget.buttonHeight,
            width: !widget.isCircle
                ? widget.buttonWidth
                : widget.isIcon
                    ? null
                    : widget.buttonWidth,
            decoration: BoxDecoration(
                shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
                borderRadius:
                    widget.isCircle ? null : BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(5, 5),
                    blurRadius: 5,
                    spreadRadius: -1,
                  ),
                ]),
            child: OutlinedButton(
              onPressed: () {},
              style: ButtonStyle(
                side: MaterialStatePropertyAll(
                    BorderSide(width: widget.isCircle ? 1.5 : 0.5)),
                surfaceTintColor: const MaterialStatePropertyAll(Colors.red),
                shadowColor: const MaterialStatePropertyAll(Colors.black54),
                padding: const MaterialStatePropertyAll(EdgeInsets.all(20.0)),
                backgroundColor: const MaterialStatePropertyAll(Colors.white),
                shape: MaterialStatePropertyAll(widget.isCircle
                    ? const CircleBorder()
                    : const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              child: widget.isIcon
                  ? IconButton(
                      iconSize: 100,
                      icon: DisplayRive(
                        rive: RiveAnimation.asset(
                          'assets/add_icon.riv',
                          fit: BoxFit.cover,
                          stateMachines: const ['State Machine 1'],
                          onInit: (artboard) {
                            _riveController =
                                StateMachineController.fromArtboard(
                                    artboard, "State Machine 1");
                            if (_riveController == null) return;
                            artboard.addController(_riveController!);
                            isClicked =
                                _riveController?.findInput<bool>("Pressed");
                          },
                        ),
                        riveHeight: 100,
                        riveWidth: 100,
                      ),
                      onPressed: () {
                        _controller.forward();
                        widget.onPress();
                        if (isClicked == null) return;
                        final isClick = isClicked?.value ?? false;
                        isClicked?.change(!isClick);
                      },
                    )
                  : Text(
                      widget.buttonName,
                      style: GoogleFonts.farro(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
