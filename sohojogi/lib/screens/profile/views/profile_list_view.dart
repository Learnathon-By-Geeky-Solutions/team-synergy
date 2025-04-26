import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/profile/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../view_model/profile_view_model.dart';
import 'profile_edit_view.dart';


class ProfileListView extends StatelessWidget {
  final VoidCallback onBackPressed;

  const ProfileListView({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final backgroundColor = isDarkMode ? darkColor : const Color(0xFFFFF8EC);
    final textColor = isDarkMode ? lightColor : darkColor;

    if (userId != null && viewModel.profileData.id.isEmpty) {
      viewModel.loadProfile(userId);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: onBackPressed,
        ),
        title: Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: primaryColor),
            onPressed: () => _navigateToEditProfile(context, viewModel.profileData),
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
    final textColor = isDarkMode ? lightColor : darkColor;
    final containerColor = isDarkMode
        ? darkColor.withAlpha((0.5 * 255).toInt())
        : grayColor.withAlpha((0.3 * 255).toInt());
    final iconColor = isDarkMode ? lightGrayColor : grayColor;

    final hasProfilePhoto = viewModel.profileData.profilePhotoUrl != null;

    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: containerColor,
              image: hasProfilePhoto
                  ? DecorationImage(
                image: NetworkImage(viewModel.profileData.profilePhotoUrl!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: hasProfilePhoto
                ? null
                : Icon(
              Icons.person,
              size: 60,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.profileData.fullName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context, ProfileViewModel viewModel, bool isDarkMode) {
    final textColor = isDarkMode ? lightColor : darkColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
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
    final textColor = isDarkMode ? lightColor : darkColor;
    final labelColor = isDarkMode ? lightGrayColor : grayColor;
    final containerColor = isDarkMode
        ? darkColor.withAlpha((0.5 * 255).toInt())
        : grayColor.withAlpha((0.1 * 255).toInt());

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: containerColor,
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
                        color: labelColor,
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
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context, ProfileModel profileData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditView(
          onBackPressed: () => Navigator.pop(context),
          profileData: profileData,
        ),
      ),
    );
  }
}