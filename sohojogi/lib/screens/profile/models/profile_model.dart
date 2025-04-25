class ProfileModel {
  String id;
  String fullName;
  String email;
  bool isEmailVerified;
  String phoneNumber;
  String gender;
  String? profilePhotoUrl;

  ProfileModel({
    this.id = '',
    this.fullName = '',
    this.email = '',
    this.isEmailVerified = false,
    this.phoneNumber = '',
    this.gender = '',
    this.profilePhotoUrl,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      isEmailVerified: map['is_email_verified'] ?? false,
      phoneNumber: map['phone_number'] ?? '',
      gender: map['gender'] ?? '',
      profilePhotoUrl: map['profile_photo_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'email': email,
      'is_email_verified': isEmailVerified,
      'phone_number': phoneNumber,
      'gender': gender,
      'profile_photo_url': profilePhotoUrl,
    };
  }

  bool get isValid {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    return fullName.isNotEmpty &&
        fullName.length >= 3 &&
        email.isNotEmpty &&
        emailRegex.hasMatch(email) &&
        phoneNumber.isNotEmpty &&
        phoneRegex.hasMatch(phoneNumber) &&
        gender.isNotEmpty;
  }
}