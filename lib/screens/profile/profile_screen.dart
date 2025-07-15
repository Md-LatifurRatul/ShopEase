import 'package:e_commerce_project/controllers/services/firebase_auth_service.dart';
import 'package:e_commerce_project/controllers/services/user_profile_service.dart';
import 'package:e_commerce_project/model/user_profile_model.dart';
import 'package:e_commerce_project/screens/profile/complete_profile_screen.dart';
import 'package:e_commerce_project/screens/profile/edit_profile_screen.dart';
import 'package:e_commerce_project/widgets/profile_info_card.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firebaseUser = FirebaseAuthService();
  UserProfileModel? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    final user = _firebaseUser.currentUser;
    if (user != null) {
      final profile = await UserProfileService.fetchUserProfile();

      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),

      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    _buildProfileImage(),

                    const SizedBox(height: 20),
                    _buildEmailInfo(),

                    const SizedBox(height: 10),

                    _userProfile != null
                        ? PrfileInfoCard(userProfile: _userProfile)
                        : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'complete your profile to see details here.',
                            style: TextStyle(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CompleteProfileScreen(),
                              ),
                            );

                            _loadUserProfile();
                          },
                          icon: Icon(Icons.person_add),

                          label: const Text("Complete Profile"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.edit),
                          label: const Text(
                            "Edit Profile",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed:
                              _userProfile == null
                                  ? null
                                  : () async {
                                    final updated = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => EditProfileScreen(
                                              userProfile: _userProfile!,
                                            ),
                                      ),
                                    );
                                    if (updated == true) {
                                      _loadUserProfile();
                                    }
                                    _loadUserProfile(); // Refresh after editing
                                  },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildEmailInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.email_rounded, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _firebaseUser.currentUser?.email ?? "No email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                'Email Address',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_userProfile?.profileImageUrl != null &&
        _userProfile!.profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(_userProfile!.profileImageUrl!),
      );
    }

    return const CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey,
      child: Icon(Icons.person, size: 50, color: Colors.white),
    );
  }
}
