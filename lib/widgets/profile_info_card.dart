import 'package:e_commerce_project/model/user_profile_model.dart';
import 'package:flutter/material.dart';

class PrfileInfoCard extends StatelessWidget {
  const PrfileInfoCard({super.key, required UserProfileModel? userProfile})
    : _userProfile = userProfile;

  final UserProfileModel? _userProfile;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            if (_userProfile!.fullName != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.person, color: Colors.deepPurple),
                title: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(_userProfile.fullName!),
              ),

            if (_userProfile.phoneNumber != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.phone, color: Colors.deepPurple),
                title: Text(
                  'Phone Number',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(_userProfile.phoneNumber!),
              ),

            if (_userProfile.country != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.flag, color: Colors.deepPurple),
                title: Text(
                  'Country',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(_userProfile.country!),
              ),
          ],
        ),
      ),
    );
  }
}
