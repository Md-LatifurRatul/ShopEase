import 'package:flutter/material.dart';

class ConfirmDialog {
  static void showAlertDialogue(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmString,
    required void Function()? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),

          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.blue)),
            ),

            TextButton(
              onPressed: onPressed,
              child: Text(
                confirmString ?? "Yes, Proceed",
                style: TextStyle(
                  color: const Color.fromARGB(255, 105, 153, 49),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
