import 'package:flutter/material.dart';

class NeoIconButton extends StatelessWidget {
  final Icon iconButton;
  final VoidCallback iconFunction;
  const NeoIconButton(
      {super.key, required this.iconButton, required this.iconFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: IconButton(
        icon: iconButton,
        onPressed: iconFunction,
      ),
    );
  }
}
