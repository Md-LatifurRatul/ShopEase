import 'dart:io';

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
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  // Future<void> _saveProfile() async {
  //   if (_formKey.currentState!.validate()) {
  //     await UserProfileService.saveUserProfile();
  //   }
  //   Navigator.pop(context, true);
  // }

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
                decoration: InputDecoration(labelText: 'Full Name'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Enter your full name"
                            : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Country'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Enter your country"
                            : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
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
                  onPressed: () {},
                  child: Text("Save Profile"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
