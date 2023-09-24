import 'package:flutter/material.dart';

/// {@category Widgets}
/// Widget für Text Elemente mit definiertem Style als H3-Element
class H3 extends StatefulWidget {
  const H3({
    super.key,
    required String text,
  }) : _text = text;

  final String _text;

  @override
  State<H3> createState() => _H3State();
}

class _H3State extends State<H3> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget._text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}