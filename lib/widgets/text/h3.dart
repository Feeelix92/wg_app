import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        widget._text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}