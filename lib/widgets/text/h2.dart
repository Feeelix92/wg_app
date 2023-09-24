import 'package:flutter/material.dart';

/// {@category Widgets}
/// Widget für Text Elemente mit definiertem Style als H2-Element
class H2 extends StatefulWidget {
  const H2({
    super.key,
    required String text,
  }) : _text = text;

  final String _text;

  @override
  State<H2> createState() => _H2State();
}

class _H2State extends State<H2> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget._text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}