import 'package:flutter/material.dart';

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
