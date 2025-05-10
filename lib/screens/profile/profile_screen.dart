import 'package:e_commerce_project/controllers/services/firebase_auth_service.dart';
import 'package:e_commerce_project/controllers/services/user_profile_service.dart';
import 'package:e_commerce_project/model/user_profile_model.dart';
import 'package:e_commerce_project/screens/profile/complete_profile_screen.dart';
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
                    Text(
                      _firebaseUser.currentUser?.email ?? "",
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 10),

                    _userProfile?.fullName != null
                        ? Column(
                          children: [
                            Text("Name: ${_userProfile!.fullName}"),
                            Text("Name: ${_userProfile!.phoneNumber}"),
                            Text("Name: ${_userProfile!.country}"),
                          ],
                        )
                        : const Text(
                          "Complete your profile to see more info...",
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
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit Profile"),
                          onPressed:
                              _userProfile == null
                                  ? null
                                  : () async {
                                    // await Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder:
                                    //         (_) => EditProfileScreen(
                                    //           userProfile: _userProfile!,
                                    //         ),
                                    //   ),
                                    // );
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

  Widget _buildProfileImage() {
    if (_userProfile?.profileImageUrl != null) {
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
