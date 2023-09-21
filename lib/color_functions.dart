import 'package:flutter/material.dart';

/// Die Methode convertToColor wandelt einen String in eine Farbe um.
Color convertToColor(String name) {
  // Name in einen Hash-Wert konvertieren
  final int hashCode = name.hashCode;

  // Hash-Wert in RGB-Werte aufteilen
  final int r = (hashCode & 0xFF0000) >> 16;
  final int g = (hashCode & 0x00FF00) >> 8;
  final int b = (hashCode & 0x0000FF);
  return Color.fromARGB(255, r, g, b);
}

/// Die Methode increaseBrightness erhöht die Helligkeit einer Farbe.
Color increaseBrightness(Color color, double factor) {
  // Faktor auf den Bereich 0.0 bis 1.0 begrenzen
  factor = factor.clamp(0.0, 1.0);

  // Farbwerte berechnen
  int red = (color.red + (255 - color.red) * factor).round();
  int green = (color.green + (255 - color.green) * factor).round();
  int blue = (color.blue + (255 - color.blue) * factor).round();

  return Color.fromARGB(color.alpha, red, green, blue);
}