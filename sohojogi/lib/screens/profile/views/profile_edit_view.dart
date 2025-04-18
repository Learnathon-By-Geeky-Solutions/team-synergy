// lib/screens/profile/views/profile_edit_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import '../view_model/profile_view_model.dart';
import '../widgets/profile_image_selection_modal.dart';
import '../widgets/profile_save_success_modal.dart';
import 'dart:io';

class ProfileEditView extends StatelessWidget {
  final VoidCallback onBackPressed;

  const ProfileEditView({
    Key? key,
    required this.onBackPressed,
  }) : super(key: key);

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
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
        actions: [
          if (viewModel.hasChanges)
            TextButton(
              onPressed: viewModel.isLoading ? null : () => _saveProfile(context),
              child: Text(
                'Save',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: _buildProfileForm(context, viewModel, isDarkMode),
    );
  }

  Widget _buildProfileForm(BuildContext context, ProfileViewModel viewModel, bool isDarkMode) {
    return ProfileFormWidget(
      viewModel: viewModel,
      isDarkMode: isDarkMode,
      onBackPressed: onBackPressed,
    );
  }

  void _saveProfile(BuildContext context) async {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final success = await viewModel.saveProfile();

    if (success && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ProfileSaveSuccessModal(
          onOkPressed: () {
            // Close the success modal
            Navigator.pop(context);
            // Navigate back to profile view
            onBackPressed();
          },
        ),
      );
    }
  }
}

class ProfileFormWidget extends StatefulWidget {
  final ProfileViewModel viewModel;
  final bool isDarkMode;
  final VoidCallback onBackPressed;

  const ProfileFormWidget({
    Key? key,
    required this.viewModel,
    required this.isDarkMode,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  State<ProfileFormWidget> createState() => _ProfileFormWidgetState();
}

class _ProfileFormWidgetState extends State<ProfileFormWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Error message fields
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _genderError;

  // Local file for profile image
  File? _profileImageFile;

  @override
  void initState() {
    super.initState();
    // Pre-fill form with existing data
    _nameController.text = widget.viewModel.profileData.fullName;
    _phoneController.text = widget.viewModel.profileData.phoneNumber;
    _emailController.text = widget.viewModel.profileData.email;

    // Add listeners to mark fields as changed
    _nameController.addListener(() {
      _validateName(_nameController.text);
      widget.viewModel.updateFullName(_nameController.text);
    });

    _phoneController.addListener(() {
      _validatePhoneNumber(_phoneController.text);
      widget.viewModel.updatePhoneNumber(_phoneController.text);
    });

    _emailController.addListener(() {
      _validateEmail(_emailController.text);
      widget.viewModel.updateEmail(_emailController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Validation methods
  bool _validateName(String name) {
    if (name.trim().isEmpty) {
      setState(() => _nameError = 'Please enter your full name');
      return false;
    }
    if (name.trim().length < 3) {
      setState(() => _nameError = 'Name must be at least 3 characters');
      return false;
    }
    setState(() => _nameError = null);
    return true;
  }

  bool _validatePhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(phone)) {
      setState(() => _phoneError = 'Please enter a valid phone number');
      return false;
    }
    setState(() => _phoneError = null);
    return true;
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _emailError = 'Please enter a valid email address');
      return false;
    }
    setState(() => _emailError = null);
    return true;
  }

  bool _validateGender() {
    if (widget.viewModel.profileData.gender.isEmpty) {
      setState(() => _genderError = 'Please select your gender');
      return false;
    }
    setState(() => _genderError = null);
    return true;
  }

  bool _validateForm() {
    final isNameValid = _validateName(_nameController.text);
    final isPhoneValid = _validatePhoneNumber(_phoneController.text);
    final isEmailValid = _validateEmail(_emailController.text);
    final isGenderValid = _validateGender();

    return isNameValid && isPhoneValid && isEmailValid && isGenderValid;
  }

  void _showProfileImageSelectionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => ProfileImageSelectionModal(
        isDarkMode: widget.isDarkMode,
        onImageSelected: (File image) {
          setState(() {
            _profileImageFile = image;
          });
          widget.viewModel.setProfileImage(image);
        },
      ),
    );
  }

  void _showGenderSelectionModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDarkMode ? darkColor : lightColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Gender',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? lightColor : darkColor,
              ),
            ),
          ),
          const Divider(),
          _buildGenderOption('Male'),
          const Divider(),
          _buildGenderOption('Female'),
          const Divider(),
          _buildGenderOption('Other'),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender) {
    return ListTile(
      title: Text(
        gender,
        style: TextStyle(
          color: widget.isDarkMode ? lightColor : darkColor,
        ),
      ),
      trailing: widget.viewModel.profileData.gender == gender
          ? Icon(Icons.check, color: primaryColor)
          : null,
      onTap: () {
        widget.viewModel.updateGender(gender);
        setState(() => _genderError = null);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Photo Section
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showProfileImageSelectionModal,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.isDarkMode ? lightGrayColor : grayColor.withOpacity(0.3),
                            image: _profileImageFile != null
                                ? DecorationImage(
                              image: FileImage(_profileImageFile!),
                              fit: BoxFit.cover,
                            )
                                : widget.viewModel.profileData.profilePhotoUrl != null
                                ? DecorationImage(
                              image: NetworkImage(widget.viewModel.profileData.profilePhotoUrl!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: widget.viewModel.profileData.profilePhotoUrl == null && _profileImageFile == null
                              ? Icon(
                            Icons.person,
                            size: 60,
                            color: widget.isDarkMode ? lightGrayColor : grayColor,
                          )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: widget.isDarkMode ? darkColor : lightColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Change Profile Photo',
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Personal Information Section
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? lightColor : darkColor,
              ),
            ),
            const SizedBox(height: 16),

            // Full Name
            _buildLabeledField('Full Name'),
            _buildTextField(
              controller: _nameController,
              hintText: 'Enter your full name',
              keyboardType: TextInputType.name,
              errorText: _nameError,
            ),
            const SizedBox(height: 16),

            // Email Address
            _buildLabeledField('Email Address'),
            _buildEmailField(),
            const SizedBox(height: 16),

            // Phone Number
            _buildLabeledField('Phone Number'),
            _buildTextField(
              controller: _phoneController,
              hintText: 'Enter your phone number',
              keyboardType: TextInputType.phone,
              errorText: _phoneError,
            ),
            const SizedBox(height: 16),

            // Gender
            _buildLabeledField('Gender'),
            _buildSelectionField(
              text: widget.viewModel.profileData.gender.isEmpty
                  ? 'Select your gender'
                  : widget.viewModel.profileData.gender,
              onTap: _showGenderSelectionModal,
              errorText: _genderError,
            ),
            const SizedBox(height: 32),

            // Error message from view model
            if (widget.viewModel.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.viewModel.errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            if (widget.viewModel.errorMessage != null)
              const SizedBox(height: 20),

            // Save button for bottom of form
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: widget.viewModel.isLoading || !widget.viewModel.hasChanges
                    ? null
                    : () {
                  if (_validateForm()) {
                    _saveProfile(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkColor,
                  foregroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: widget.viewModel.isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile(BuildContext context) async {
    final success = await widget.viewModel.saveProfile();

    if (success && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ProfileSaveSuccessModal(
          onOkPressed: () {
            // Close the success modal
            Navigator.pop(context);
            // Navigate back to profile view
            widget.onBackPressed();
          },
        ),
      );
    }
  }

  Widget _buildLabeledField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: widget.isDarkMode ? lightColor : darkColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: errorText != null
                  ? Colors.red
                  : (widget.isDarkMode ? grayColor.withOpacity(0.3) : grayColor.withOpacity(0.3)),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              color: widget.isDarkMode ? lightColor : darkColor,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: hintText,
              hintStyle: TextStyle(
                color: widget.isDarkMode ? lightGrayColor : grayColor,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _emailError != null
                  ? Colors.red
                  : (widget.isDarkMode ? grayColor.withOpacity(0.3) : grayColor.withOpacity(0.3)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: widget.isDarkMode ? lightColor : darkColor,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    hintText: 'Enter your email address',
                    hintStyle: TextStyle(
                      color: widget.isDarkMode ? lightGrayColor : grayColor,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (widget.viewModel.profileData.isEmailVerified)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: TextButton(
                    onPressed: () {
                      // Handle verify email action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Verification email sent')),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Verify',
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_emailError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              _emailError!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSelectionField({
    required String text,
    required VoidCallback onTap,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: errorText != null
                    ? Colors.red
                    : (widget.isDarkMode ? grayColor.withOpacity(0.3) : grayColor.withOpacity(0.3)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: text == 'Select your gender'
                          ? (widget.isDarkMode ? lightGrayColor : grayColor)
                          : (widget.isDarkMode ? lightColor : darkColor),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: widget.isDarkMode ? lightGrayColor : grayColor,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}