class UserProfileModel {
  final String uid;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? country;
  final String? profileImageUrl;

  UserProfileModel({
    required this.uid,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.country,
    this.profileImageUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      uid: json["uid"],
      email: json["email"],
      fullName: json["fullName"],

      phoneNumber: json['phoneNumber'],
      country: json['country'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      'email': email,

      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'country': country,
      'profileImageUrl': profileImageUrl,
    };
  }

  UserProfileModel copyWith({
    String? fullName,
    String? email,
    String? country,
    String? phoneNumber,
    String? photoUrl,
  }) {
    return UserProfileModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: photoUrl ?? profileImageUrl,
    );
  }
}
