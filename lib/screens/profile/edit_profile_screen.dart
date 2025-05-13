import 'dart:io';

import 'package:e_commerce_project/model/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.userProfile});
  final UserProfileModel userProfile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _newImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.userProfile.fullName ?? "";

    _countryController.text = widget.userProfile.country ?? '';
    _phoneController.text = widget.userProfile.phoneNumber ?? '';
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _newImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveProfile() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Your Profile")),

      body:
          _isSaving
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              _newImage != null
                                  ? FileImage(_newImage!)
                                  : (widget.userProfile.profileImageUrl != null
                                          ? NetworkImage(
                                            widget.userProfile.profileImageUrl!,
                                          )
                                          : null)
                                      as ImageProvider?,
                          child:
                              (_newImage == null &&
                                      widget.userProfile.profileImageUrl ==
                                          null)
                                  ? const Icon(Icons.add_a_photo, size: 40)
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _countryController,
                        decoration: const InputDecoration(labelText: 'Country'),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Enter your country"
                                    : null,
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Enter your phone number"
                                    : null,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("Save Changes"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
