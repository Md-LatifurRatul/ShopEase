import 'dart:io';

import 'package:e_commerce_project/controllers/services/firebase_auth_service.dart';
import 'package:e_commerce_project/controllers/services/user_profile_service.dart';
import 'package:e_commerce_project/model/user_profile_model.dart';
import 'package:e_commerce_project/widgets/country_selector_field.dart';
import 'package:e_commerce_project/widgets/toast_meesage.dart';
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
  String? _selectedCountry;
  final TextEditingController _phoneController = TextEditingController();
  File? _newImage;
  bool _isSaving = false;
  final _firebaseUser = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.userProfile.fullName ?? "";

    _selectedCountry = widget.userProfile.country ?? '';
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

  Future<void> _saveProfile() async {
    final user = _firebaseUser.currentUser;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      String? imageUrl = widget.userProfile.profileImageUrl;

      if (_newImage != null) {
        final bytes = await _newImage!.readAsBytes();
        imageUrl = await UserProfileService.uploadProfileImage(bytes);
      }

      final updatedProfile = UserProfileModel(
        uid: widget.userProfile.uid,
        fullName: _fullNameController.text.trim(),
        country: _selectedCountry,
        phoneNumber: _phoneController.text.trim(),
        profileImageUrl: imageUrl,

        email: user!.email!,
      );

      await UserProfileService.saveUserProfile(updatedProfile);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      ToastMeesage.showToastMessage(context, 'Failed to update profile');
    } finally {
      setState(() => _isSaving = false);
    }
  }

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
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',

                          suffixIcon: Icon(Icons.person_outline),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Enter your name"
                                    : null,
                      ),

                      CountrySelectorField(
                        selectedCountry: _selectedCountry,
                        label: "Country",
                        onCountrySelected: (country) {
                          setState(() {
                            _selectedCountry = country;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          suffixIcon: Icon(Icons.phone),
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
                            backgroundColor: Colors.teal,
                          ),
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
