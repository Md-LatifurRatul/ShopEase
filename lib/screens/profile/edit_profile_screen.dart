import 'package:e_commerce_project/model/user_profile_model.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key, required this.userProfile});
  final UserProfileModel userProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Edit Your Profile")));
  }
}
