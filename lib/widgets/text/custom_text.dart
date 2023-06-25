import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  const CustomText({
    super.key,
    required String text,
  }) : _text = text;

  final String _text;

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        widget._text,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}