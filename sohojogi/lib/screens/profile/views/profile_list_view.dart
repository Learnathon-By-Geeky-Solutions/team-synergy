import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import '../view_model/profile_view_model.dart';
import 'profile_edit_view.dart';

class ProfileListView extends StatelessWidget {
  final VoidCallback onBackPressed;

  const ProfileListView({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? darkColor : const Color(0xFFFFF8EC),
      appBar: AppBar(
        backgroundColor: isDarkMode ? darkColor : const Color(0xFFFFF8EC),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? lightColor : darkColor,
          ),
          onPressed: onBackPressed,
        ),
        title: Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: primaryColor,
            ),
            onPressed: () => _navigateToEditProfile(context),
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildProfileContent(context, viewModel, isDarkMode),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileViewModel viewModel, bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(context, viewModel, isDarkMode),
          const SizedBox(height: 24),
          _buildProfileDetails(context, viewModel, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileViewModel viewModel, bool isDarkMode) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode ? darkColor.withValues(alpha: 0.5) : grayColor.withValues(alpha: 0.3),
              image: viewModel.profileData.profilePhotoUrl != null
                  ? DecorationImage(
                image: NetworkImage(viewModel.profileData.profilePhotoUrl!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: viewModel.profileData.profilePhotoUrl == null
                ? Icon(
              Icons.person,
              size: 60,
              color: isDarkMode ? lightGrayColor : grayColor,
            )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.profileData.fullName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? lightColor : darkColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context, ProfileViewModel viewModel, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoItem(
          context,
          'Email',
          viewModel.profileData.email,
          Icons.email,
          isDarkMode,
          isVerified: viewModel.profileData.isEmailVerified,
        ),
        _buildInfoItem(
          context,
          'Phone',
          viewModel.profileData.phoneNumber,
          Icons.phone,
          isDarkMode,
        ),
        _buildInfoItem(
          context,
          'Gender',
          viewModel.profileData.gender,
          Icons.person,
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildInfoItem(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      bool isDarkMode, {
        bool isVerified = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDarkMode ? darkColor.withValues(alpha: 0.5) : grayColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? lightGrayColor : grayColor,
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Verified',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? lightColor : darkColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditView(
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}