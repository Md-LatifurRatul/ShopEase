import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/model/user_profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileService {
  static final _firestore = FirebaseFirestore.instance;

  static final _auth = FirebaseAuth.instance;
  static final _supabase = Supabase.instance.client;

  // ! Save Profile Info

  static Future<String?> uploadProfileImage(Uint8List image) async {
    try {
      final fileName = "profile_${DateTime.now().millisecondsSinceEpoch}.jpg";

      final response = await _supabase.storage
          .from("userimage")
          .updateBinary(
            fileName,
            image,
            fileOptions: const FileOptions(contentType: "image/jpeg"),
          );

      if (response.isEmpty) return null;

      return _supabase.storage.from('userimage').getPublicUrl(fileName);
    } catch (e) {
      print("Error uploading");
      return null;
    }
  }

  static Future<void> saveUserProfile(UserProfileModel profile) async {
    try {
      await _firestore
          .collection("users")
          .doc(profile.uid)
          .set(profile.toJson(), SetOptions(merge: true));
    } catch (e) {
      print("Error saving profile");
    }
  }

  // ! Fetch Profile Info

  static Future<UserProfileModel?> fetchUserProfile() async {
    final user = _auth.currentUser;

    if (user == null) return null;

    try {
      final doc = await _firestore.collection("users").doc(user.uid).get();

      if (!doc.exists) return null;
      return UserProfileModel.fromJson(doc.data()!);
    } catch (e) {
      print("Error fetching profile: $e");
      return null;
    }
  }
}
