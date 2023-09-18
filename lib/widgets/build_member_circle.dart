import 'package:flutter/material.dart';
import 'package:wg_app/data/constants.dart';

Widget buildMemberCircle(String name, double size, double brightness) {
  Color circleColor = increaseBrightness(convertToColor(name), brightness);
  double fontSize = size / 2;
  return GestureDetector(
    onTap: () {},
    child: Tooltip(
      message: name,
      showDuration: const Duration(seconds: 3),
      textStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: circleColor,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Container(
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
      ),
    ),
  );
}
