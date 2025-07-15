import 'package:flutter/material.dart';

class CustomAuthElevatedButton extends StatelessWidget {
  const CustomAuthElevatedButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
  });

  final String buttonName;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,

      child: Text(buttonName, style: TextStyle(color: Colors.white)),
    );
  }
}
