import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:wg_app/data/constants.dart';

Widget buildMemberCircle(String name, double width, double height, double brightness) {
  Color circleColor = increaseBrightness(convertToColor(name), brightness);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
      ),
      child: Center(
        child: Text(
          name[0],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}