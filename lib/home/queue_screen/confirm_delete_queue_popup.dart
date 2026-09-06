import 'package:flatter/main.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteQueuePopup {
  static void showConfirmDeleteQueuePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Clear queue?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                playerControl.customAction('clearQueue');
                Navigator.of(context).pop();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      }
    );
  }
}