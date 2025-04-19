// lib/screens/profile/view_model/profile_view_model.dart
import 'package:flutter/material.dart';
import 'dart:io';
import '../models/profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileModel _profileData = ProfileModel();
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasChanges = false;
  File? _profileImageFile;

  // Getters
  ProfileModel get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasChanges => _hasChanges;

  // Constructor - load data when created
  ProfileViewModel() {
    loadProfile();
  }

  // Load profile data
  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(milliseconds: 800));

      // In a real app, you would fetch from API
      _profileData = ProfileModel(
        fullName: 'John Doe',
        email: 'johndoe@example.com',
        isEmailVerified: true,
        phoneNumber: '+1 234 567 8901',
        gender: 'Male',
        profilePhotoUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
      );

      _isLoading = false;
      _hasChanges = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load profile data. Please try again.';
      notifyListeners();
    }
  }

  // Update methods
  void updateFullName(String name) {
    if (_profileData.fullName != name) {
      _profileData = ProfileModel(
        fullName: name,
        email: _profileData.email,
        isEmailVerified: _profileData.isEmailVerified,
        phoneNumber: _profileData.phoneNumber,
        gender: _profileData.gender,
        profilePhotoUrl: _profileData.profilePhotoUrl,
      );
      _hasChanges = true;
      notifyListeners();
    }
  }

  void updateEmail(String email) {
    if (_profileData.email != email) {
      _profileData = ProfileModel(
        fullName: _profileData.fullName,
        email: email,
        isEmailVerified: email == _profileData.email ? _profileData.isEmailVerified : false,
        phoneNumber: _profileData.phoneNumber,
        gender: _profileData.gender,
        profilePhotoUrl: _profileData.profilePhotoUrl,
      );
      _hasChanges = true;
      notifyListeners();
    }
  }

  void updatePhoneNumber(String phoneNumber) {
    if (_profileData.phoneNumber != phoneNumber) {
      _profileData = ProfileModel(
        fullName: _profileData.fullName,
        email: _profileData.email,
        isEmailVerified: _profileData.isEmailVerified,
        phoneNumber: phoneNumber,
        gender: _profileData.gender,
        profilePhotoUrl: _profileData.profilePhotoUrl,
      );
      _hasChanges = true;
      notifyListeners();
    }
  }

  void updateGender(String gender) {
    if (_profileData.gender != gender) {
      _profileData = ProfileModel(
        fullName: _profileData.fullName,
        email: _profileData.email,
        isEmailVerified: _profileData.isEmailVerified,
        phoneNumber: _profileData.phoneNumber,
        gender: gender,
        profilePhotoUrl: _profileData.profilePhotoUrl,
      );
      _hasChanges = true;
      notifyListeners();
    }
  }

  void updateProfileImage(File image) {
    _profileImageFile = image;
    // In a real app, you would upload the image to a server
    // and then update the profilePhotoUrl
    _hasChanges = true;
    notifyListeners();
  }

  // Save profile changes
  Future<bool> saveProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would send the data to an API
      if (_profileImageFile != null) {
        // Simulate image upload
        // profileData.profilePhotoUrl would be updated with the new URL
      }

      _isLoading = false;
      _hasChanges = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to save profile. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // Reset any error messages
  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }
}