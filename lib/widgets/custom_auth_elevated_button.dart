import 'package:e_commerce_project/widgets/toast_meesage.dart';
import 'package:flutter/material.dart';

class CustomAuthElevatedButton extends StatelessWidget {
  const CustomAuthElevatedButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.buttonName,
    required this.authSuccessMessage,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final String buttonName;
  final String authSuccessMessage;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ToastMeesage.showToastMessage(context, authSuccessMessage);
        }
      },

      child: Text(buttonName, style: TextStyle(color: Colors.white)),
    );
  }
}
