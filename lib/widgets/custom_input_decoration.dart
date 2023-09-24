import 'package:flutter/material.dart';

/// {@category Widgets}
/// Custom [InputDecoration] für die Verwendung bei [TextField]s.
InputDecoration materialInputDecoration(String label, String? helper, IconData icon) {
  return InputDecoration(
    labelText: label,
    helperText: helper,
    prefixIcon: Icon(icon),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );
}
