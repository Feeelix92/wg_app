import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// {@category Widgets}
/// Widget für die Anzeige eines Error Dialogs mit den übergebenen Parametern
Future<dynamic> customErrorDialog(BuildContext context, String title, String content) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            AutoRouter.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

