import 'dart:io';
import 'dart:typed_data';

import 'package:e_commerce_project/controllers/services/firebase_auth_service.dart';
import 'package:e_commerce_project/controllers/services/user_profile_service.dart';
import 'package:e_commerce_project/model/user_profile_model.dart';
import 'package:e_commerce_project/widgets/country_selector_field.dart';
import 'package:e_commerce_project/widgets/toast_meesage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  String? _selectedCountry;
  final _phoneController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    } catch (e) {
      print("Image picking error: $e");
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    final user = _firebaseAuthService.currentUser;

    if (user == null) {
      ToastMeesage.showToastMessage(context, "No user found");
      setState(() {
        _isLoading = false;
        return;
      });
    }

    String? imageUrl;
    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      imageUrl = await UserProfileService.uploadProfileImage(
        Uint8List.fromList(bytes),
      );
    }

    final profile = UserProfileModel(
      uid: user!.uid,
      fullName: _fullNameController.text.trim(),

      email: user.email!,
      country: _selectedCountry ?? '',
      phoneNumber: _phoneController.text.trim(),
      profileImageUrl: imageUrl,
    );

    await UserProfileService.saveUserProfile(profile);

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Your Profile")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,

          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                  child:
                      _selectedImage == null
                          ? Icon(Icons.add_a_photo, size: 40)
                          : null,
                ),
              ),

              SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,

                decoration: InputDecoration(
                  labelText: 'Full Name',

                  suffixIcon: Icon(Icons.person),
                ),

                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Enter your full name"
                            : null,
              ),
              SizedBox(height: 20),

              CountrySelectorField(
                selectedCountry: _selectedCountry,
                label: "Country",
                onCountrySelected: (country) {
                  setState(() {
                    _selectedCountry = country;
                  });
                },
              ),

              SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  suffixIcon: Icon(Icons.phone),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Enter your phone number"
                            : null,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: _isLoading ? null : _saveProfile,
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Save Profile"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
