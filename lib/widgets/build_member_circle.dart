import 'package:flutter/material.dart';
import 'package:wg_app/data/constants.dart';

Widget buildMemberCircle(String name) {
  Color circleColor = increaseBrightness(convertToColor(name), 0.1);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
      ),
      child: Center(
        child: Text(
          name[0],
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}