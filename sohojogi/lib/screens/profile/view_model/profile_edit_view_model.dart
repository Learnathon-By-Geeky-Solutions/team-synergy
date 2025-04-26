import 'package:flutter/material.dart';
import 'package:sohojogi/screens/profile/models/profile_model.dart';
import 'dart:io';
import '../../../base/services/profile_service.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final ProfileService _profileService;
  final ProfileModel _profileData;
  final ProfileModel _originalData;
  bool _isLoading = false;
  String? _errorMessage;
  File? _newProfileImage;

  ProfileEditViewModel({
    required ProfileModel initialData,
    ProfileService? profileService,
  }) : _profileService = profileService ?? ProfileService(),
        _profileData = initialData.copy(),
        _originalData = initialData;

  ProfileModel get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasChanges => _newProfileImage != null || !_profileData.equals(_originalData);

  void updateFullName(String value) {
    _profileData.fullName = value;
    notifyListeners();
  }

  void updatePhoneNumber(String value) {
    _profileData.phoneNumber = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    _profileData.email = value;
    notifyListeners();
  }

  void updateGender(String value) {
    _profileData.gender = value;
    notifyListeners();
  }

  void setProfileImage(File image) {
    _newProfileImage = image;
    notifyListeners();
  }

  Future<bool> saveProfile(String userId) async {
    if (!_profileData.isValid) {
      _errorMessage = 'Please fill all required fields';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (_newProfileImage != null) {
        _profileData.profilePhotoUrl = await _profileService.uploadProfilePicture(
          userId,
          _newProfileImage!.path,
        );
      }
      await _profileService.updateProfile(userId, _profileData.toMap());
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
