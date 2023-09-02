import 'package:flutter/material.dart';

class Constants {
  static const String appName = 'Liv2Gether';
}

Color convertToColor(String name) {
  // Name in einen Hash-Wert konvertieren
  final int hashCode = name.hashCode;
  final int r = (hashCode & 0xFF0000) >> 16;
  final int g = (hashCode & 0x00FF00) >> 8;
  final int b = (hashCode & 0x0000FF);
  return Color.fromARGB(255, r, g, b);
}

Color increaseBrightness(Color color, double factor) {
  factor = factor.clamp(0.0, 1.0);

  int red = (color.red + (255 - color.red) * factor).round();
  int green = (color.green + (255 - color.green) * factor).round();
  int blue = (color.blue + (255 - color.blue) * factor).round();

  return Color.fromARGB(color.alpha, red, green, blue);
}

