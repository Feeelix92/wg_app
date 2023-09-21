import 'package:flutter/material.dart';

/// Zeigt eine Snackbar mit einem Icon und einer Nachricht an.
void showAwesomeSnackbar(BuildContext context, String message, Color color, IconData icon) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Text(message),
          const SizedBox(width: 12),
        ],
      ),
    ),
  );
}
