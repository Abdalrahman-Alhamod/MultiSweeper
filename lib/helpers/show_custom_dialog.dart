import 'package:flutter/material.dart';

Future<dynamic> showCustomDialog(
    BuildContext context, String title, String message) {
  return showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        contentPadding: const EdgeInsets.all(24),
        title: Text(title),
        children: [Text(message)],
      );
    },
  );
}
