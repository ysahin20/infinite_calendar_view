import 'package:flutter/material.dart';

showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.surface),
      ),
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      duration: Duration(seconds: 1),
      showCloseIcon: true,
      closeIconColor: Theme.of(context).colorScheme.surface,
    ),
  );
}

String getSlotHourText(DateTime start, DateTime end) {
  return start.hour.toString().padLeft(2, '0') +
      ":" +
      start.hour.toString().padLeft(2, '0') +
      "\n" +
      end.hour.toString().padLeft(2, '0') +
      ":" +
      end.hour.toString().padLeft(2, '0');
}
