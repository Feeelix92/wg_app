import 'package:flutter/material.dart';
import 'package:wg_app/data/constants.dart';

Widget buildMemberCircle(String name, double size, double brightness) {
  Color circleColor = increaseBrightness(convertToColor(name), brightness);
  double fontSize = size / 2;
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: circleColor,
    ),
    child: Center(
      child: Text(
        name[0],
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}