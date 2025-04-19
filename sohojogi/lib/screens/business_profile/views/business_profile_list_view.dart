// lib/screens/business_profile/views/worker_registration_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import '../view_model/worker_registration_view_model.dart';
import '../widgets/work_type_selection_modal.dart';
import '../widgets/country_selection_modal.dart';
import '../widgets/registration_success_modal.dart';
import 'worker_benefits_view.dart';

class BusinessProfileListView extends StatefulWidget {
  final VoidCallback onBackPressed;

  const BusinessProfileListView({
    Key? key,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  State<BusinessProfileListView> createState() => _BusinessProfileListViewState();
}

class _BusinessProfileListViewState extends State<BusinessProfileListView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<WorkerRegistrationViewModel>(context, listen: false);

    // Pre-fill form if there's existing data
    _nameController.text = viewModel.registrationData.fullName;
    _phoneController.text = viewModel.registrationData.phoneNumber;
    _emailController.text = viewModel.registrationData.email;
    if (viewModel.registrationData.yearsOfExperience > 0) {
      _yearsController.text = viewModel.registrationData.yearsOfExperience.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  void _showWorkTypeSelectionModal() {
    final viewModel = context.read<WorkerRegistrationViewModel>();

    // No need to check if workTypes is empty since it's pre-initialized in the ViewModel

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WorkTypeSelectionModal(
        workTypes: viewModel.workTypes,
        onToggleWorkType: viewModel.toggleWorkType,
      ),
    );
  }

  void _showCountrySelectionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CountrySelectionModal(
        countries: context.read<WorkerRegistrationViewModel>().countries,
        onToggleCountry: context.read<WorkerRegistrationViewModel>().toggleCountry,
      ),
    );
  }

  void _showSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RegistrationSuccessModal(
        onOkPressed: () {
          Navigator.of(context).pop();
          context.read<WorkerRegistrationViewModel>().resetForm();
        },
      ),
    );
  }

  void _submitForm() async {
    final viewModel = context.read<WorkerRegistrationViewModel>();

    // Update view model with form values
    viewModel.updateFullName(_nameController.text);
    viewModel.updatePhoneNumber(_phoneController.text);
    viewModel.updateEmail(_emailController.text);
    if (_yearsController.text.isNotEmpty) {
      viewModel.updateYearsOfExperience(int.tryParse(_yearsController.text) ?? 0);
    }

    final success = await viewModel.submitRegistration();
    if (success && mounted) {
      _showSuccessModal();
    }
  }

  void _navigateToBenefits() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WorkerBenefitsView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final viewModel = context.watch<WorkerRegistrationViewModel>();

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
          onPressed: widget.onBackPressed,
        ),
        title: Text(
          'Become A Worker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form title and description
              Text(
                'Worker Registration',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? lightColor : darkColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill in your details to register as a skilled worker.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? lightGrayColor : grayColor,
                ),
              ),
              const SizedBox(height: 24),

              // Full Name
              _buildLabeledField('Full Name'),
              _buildTextField(
                controller: _nameController,
                hintText: 'Enter your full name',
                onChanged: viewModel.updateFullName,
              ),
              const SizedBox(height: 16),

              // Phone Number
              _buildLabeledField('Phone Number'),
              _buildTextField(
                controller: _phoneController,
                hintText: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                onChanged: viewModel.updatePhoneNumber,
              ),
              const SizedBox(height: 16),

              // Email Address
              _buildLabeledField('Email Address'),
              _buildTextField(
                controller: _emailController,
                hintText: 'Enter your email address',
                keyboardType: TextInputType.emailAddress,
                onChanged: viewModel.updateEmail,
              ),
              const SizedBox(height: 16),

              // Work Type
              _buildLabeledField('Work Type'),
              _buildSelectionField(
                text: viewModel.getSelectedWorkTypesText(),
                onTap: _showWorkTypeSelectionModal,
              ),
              const SizedBox(height: 16),

              // Years of Experience
              _buildLabeledField('Years of Experience'),
              _buildTextField(
                controller: _yearsController,
                hintText: 'Enter years of experience',
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  viewModel.updateYearsOfExperience(int.tryParse(value) ?? 0);
                },
              ),
              const SizedBox(height: 16),

              // Experience Country
              _buildLabeledField('Experience Country'),
              _buildSelectionField(
                text: viewModel.getSelectedCountryText(),
                onTap: _showCountrySelectionModal,
              ),
              const SizedBox(height: 32),

              // Error message
              if (viewModel.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              if (viewModel.errorMessage != null)
                const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: viewModel.isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkColor,
                  foregroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: viewModel.isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Learn about benefits
              Center(
                child: TextButton(
                  onPressed: _navigateToBenefits,
                  child: Text(
                    'Learn about worker benefits',
                    style: TextStyle(
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField(String label) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? lightColor : darkColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode ? grayColor.withOpacity(0.3) : grayColor.withOpacity(0.3),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: TextStyle(
          color: isDarkMode ? lightColor : darkColor,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDarkMode ? lightGrayColor : grayColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSelectionField({
    required String text,
    required VoidCallback onTap,
  }) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDarkMode ? grayColor.withOpacity(0.3) : grayColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: text.contains('e.g.') || text == 'Select Country'
                      ? (isDarkMode ? lightGrayColor : grayColor)
                      : (isDarkMode ? lightColor : darkColor),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: isDarkMode ? lightGrayColor : grayColor,
            ),
          ],
        ),
      ),
    );
  }
}