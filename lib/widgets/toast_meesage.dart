import 'package:flutter/material.dart';

class ToastMeesage {
  static void showToastMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: Duration(milliseconds: 500), content: Text(msg)),
    );
  }
}
