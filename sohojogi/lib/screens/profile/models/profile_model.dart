class ProfileModel {
  String fullName;
  String email;
  bool isEmailVerified;
  String phoneNumber;
  String gender;
  String? profilePhotoUrl;

  ProfileModel({
    this.fullName = '',
    this.email = '',
    this.isEmailVerified = false,
    this.phoneNumber = '',
    this.gender = '',
    this.profilePhotoUrl,
  });

  bool get isValid {
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        gender.isNotEmpty;
  }
}