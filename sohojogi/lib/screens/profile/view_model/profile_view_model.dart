// lib/screens/profile/view_model/profile_view_model.dart
import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import 'dart:io';

class ProfileViewModel extends ChangeNotifier {
  ProfileModel _profileData = ProfileModel(
    fullName: 'John Doe',
    email: 'john.doe@example.com',
    isEmailVerified: true,
    phoneNumber: '+1234567890',
    gender: 'Male',
  );

  ProfileModel _originalProfileData = ProfileModel();
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasChanges = false;
  File? _newProfileImage;

  // Getters
  ProfileModel get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasChanges => _hasChanges;
  File? get newProfileImage => _newProfileImage;

  // Constructor - load initial data
  ProfileViewModel() {
    _loadProfile();
    _originalProfileData = ProfileModel(
      fullName: _profileData.fullName,
      email: _profileData.email,
      isEmailVerified: _profileData.isEmailVerified,
      phoneNumber: _profileData.phoneNumber,
      gender: _profileData.gender,
      profilePhotoUrl: _profileData.profilePhotoUrl,
    );
  }

  // Mock loading profile data
  Future<void> _loadProfile() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _isLoading = false;
    notifyListeners();
  }

  // Update methods
  void updateFullName(String value) {
    _profileData.fullName = value;
    _checkForChanges();
    notifyListeners();
  }

  void updateEmail(String value) {
    _profileData.email = value;
    _checkForChanges();
    notifyListeners();
  }

  void updatePhoneNumber(String value) {
    _profileData.phoneNumber = value;
    _checkForChanges();
    notifyListeners();
  }

  void updateGender(String value) {
    _profileData.gender = value;
    _checkForChanges();
    notifyListeners();
  }

  void setProfileImage(File image) {
    _newProfileImage = image;
    _hasChanges = true;
    notifyListeners();
  }

  void _checkForChanges() {
    _hasChanges = _profileData.fullName != _originalProfileData.fullName ||
        _profileData.email != _originalProfileData.email ||
        _profileData.phoneNumber != _originalProfileData.phoneNumber ||
        _profileData.gender != _originalProfileData.gender ||
        _newProfileImage != null;
  }

  Future<bool> saveProfile() async {
    if (!_profileData.isValid) {
      _errorMessage = 'Please fill all required fields';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update the original data after successful save
      _originalProfileData = ProfileModel(
        fullName: _profileData.fullName,
        email: _profileData.email,
        isEmailVerified: _profileData.isEmailVerified,
        phoneNumber: _profileData.phoneNumber,
        gender: _profileData.gender,
        profilePhotoUrl: _profileData.profilePhotoUrl,
      );

      _newProfileImage = null;
      _hasChanges = false;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to save profile. Please try again.';
      notifyListeners();
      return false;
    }
  }

  void resetChanges() {
    _profileData = ProfileModel(
      fullName: _originalProfileData.fullName,
      email: _originalProfileData.email,
      isEmailVerified: _originalProfileData.isEmailVerified,
      phoneNumber: _originalProfileData.phoneNumber,
      gender: _originalProfileData.gender,
      profilePhotoUrl: _originalProfileData.profilePhotoUrl,
    );
    _newProfileImage = null;
    _hasChanges = false;
    _errorMessage = null;
    notifyListeners();
  }
}