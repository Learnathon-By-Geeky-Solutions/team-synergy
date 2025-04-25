import 'package:flutter/material.dart';
import 'dart:io';
import '../models/profile_model.dart';
import '../../../base/services/profile_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService;
  ProfileModel _profileData = ProfileModel();
  ProfileModel? _originalData;
  bool _isLoading = false;
  String? _errorMessage;
  File? _newProfileImage;

  ProfileViewModel({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService();

  // Getters
  ProfileModel get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  File? get newProfileImage => _newProfileImage;

  // Add hasChanges getter to check if profile data has been modified
  bool get hasChanges {
    if (_newProfileImage != null) return true;
    if (_originalData == null) return false;

    return _profileData.fullName != _originalData!.fullName ||
        _profileData.email != _originalData!.email ||
        _profileData.phoneNumber != _originalData!.phoneNumber ||
        _profileData.gender != _originalData!.gender;
  }

  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _profileService.fetchProfile(userId);
      if (data != null) {
        _profileData = ProfileModel.fromMap(data);
        _originalData = ProfileModel.fromMap(data); // Store original data
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFullName(String value) {
    _profileData.fullName = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    _profileData.email = value;
    notifyListeners();
  }

  void updatePhoneNumber(String value) {
    _profileData.phoneNumber = value;
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

  Future<bool> saveProfile([String? userId]) async {
    if (!_profileData.isValid) {
      _errorMessage = 'Please fill all required fields';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (_newProfileImage != null && userId != null) {
        print("Uploading image from path: ${_newProfileImage!.path}");
        final imageUrl = await _profileService.uploadProfilePicture(
          userId,
          _newProfileImage!.path,
        );
        print("Image uploaded, URL: $imageUrl");
        _profileData.profilePhotoUrl = imageUrl;
      }

      print("Updating profile with data: ${_profileData.toMap()}");
      await _profileService.updateProfile(userId ?? _profileData.id, _profileData.toMap());
      _originalData = ProfileModel.fromMap(_profileData.toMap());
      _errorMessage = null;
      return true;
    } catch (e) {
      print("Error saving profile: $e");
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
