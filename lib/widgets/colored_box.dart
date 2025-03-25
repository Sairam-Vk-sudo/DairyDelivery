import 'package:flutter/material.dart';

class ColoredBoxWidget extends StatelessWidget {
  const ColoredBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      color: Colors.amber,
      margin: const EdgeInsets.only(top: 50),
    );
  }
}
