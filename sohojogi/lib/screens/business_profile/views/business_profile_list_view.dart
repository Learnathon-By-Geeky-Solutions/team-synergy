import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import '../view_model/worker_registration_view_model.dart';
import '../widgets/work_type_selection_modal.dart';
import '../widgets/country_selection_modal.dart';
import '../widgets/registration_success_modal.dart';
import 'worker_benefits_view.dart';

class BusinessProfileListView extends StatelessWidget {
  final VoidCallback onBackPressed;

  const BusinessProfileListView({
    super.key,
    required this.onBackPressed,
  });

  Color _getBackgroundColor(bool isDarkMode) {
    return isDarkMode ? darkColor : const Color(0xFFFFF8EC);
  }

  Color _getTextColor(bool isDarkMode) {
    return isDarkMode ? lightColor : darkColor;
  }

  @override
  Widget build(BuildContext context) {
    // Access the view model to verify it exists
    final viewModel = Provider.of<WorkerRegistrationViewModel>(context);
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _getBackgroundColor(isDarkMode),
      appBar: AppBar(
        backgroundColor: _getBackgroundColor(isDarkMode),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _getTextColor(isDarkMode),
          ),
          onPressed: onBackPressed,
        ),
        title: Text(
          'Become A Worker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _getTextColor(isDarkMode),
          ),
        ),
      ),
      body: _buildRegistrationForm(context, viewModel, isDarkMode),
    );
  }

  Widget _buildRegistrationForm(BuildContext context, WorkerRegistrationViewModel viewModel, bool isDarkMode) {
    return RegistrationFormWidget(
      viewModel: viewModel,
      isDarkMode: isDarkMode,
      onBackPressed: onBackPressed,
    );
  }
}

// Extract the form implementation to a separate stateful widget
class RegistrationFormWidget extends StatefulWidget {
  final WorkerRegistrationViewModel viewModel;
  final bool isDarkMode;
  final VoidCallback onBackPressed;

  const RegistrationFormWidget({
    super.key,
    required this.viewModel,
    required this.isDarkMode,
    required this.onBackPressed,
  });

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  // Error message fields
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _yearsError;
  String? _workTypeError;
  String? _countryError;

  @override
  void initState() {
    super.initState();
    // Pre-fill form if there's existing data
    _nameController.text = widget.viewModel.registrationData.fullName;
    _phoneController.text = widget.viewModel.registrationData.phoneNumber;
    _emailController.text = widget.viewModel.registrationData.email;
    if (widget.viewModel.registrationData.yearsOfExperience > 0) {
      _yearsController.text = widget.viewModel.registrationData.yearsOfExperience.toString();
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
    // Basic phone validation (can be made more complex for specific formats)
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(phone)) {
      setState(() => _phoneError = 'Please enter a valid phone number');
      return false;
    }
    setState(() => _phoneError = null);
    return true;
  }

  bool _validateEmail(String email) {
    // Email validation using regex
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _emailError = 'Please enter a valid email address');
      return false;
    }
    setState(() => _emailError = null);
    return true;
  }

  bool _validateYearsOfExperience(String years) {
    if (years.isEmpty) {
      setState(() => _yearsError = 'Please enter years of experience');
      return false;
    }

    final yearsValue = int.tryParse(years);
    if (yearsValue == null || yearsValue <= 0) {
      setState(() => _yearsError = 'Experience must be a positive number');
      return false;
    }

    if (yearsValue > 50) {
      setState(() => _yearsError = 'Please enter a reasonable value');
      return false;
    }

    setState(() => _yearsError = null);
    return true;
  }

  bool _validateWorkType() {
    if (widget.viewModel.registrationData.selectedWorkTypes.isEmpty) {
      setState(() => _workTypeError = 'Please select at least one work type');
      return false;
    }
    setState(() => _workTypeError = null);
    return true;
  }

  bool _validateCountry() {
    if (widget.viewModel.registrationData.experienceCountry.isEmpty) {
      setState(() => _countryError = 'Please select a country');
      return false;
    }
    setState(() => _countryError = null);
    return true;
  }

  bool _validateForm() {
    // Validate all fields
    final isNameValid = _validateName(_nameController.text);
    final isPhoneValid = _validatePhoneNumber(_phoneController.text);
    final isEmailValid = _validateEmail(_emailController.text);
    final isYearsValid = _validateYearsOfExperience(_yearsController.text);
    final isWorkTypeValid = _validateWorkType();
    final isCountryValid = _validateCountry();

    // Return true only if all validations pass
    return isNameValid && isPhoneValid && isEmailValid &&
        isYearsValid && isWorkTypeValid && isCountryValid;
  }

  void _showWorkTypeSelectionModal() {
    final viewModel = Provider.of<WorkerRegistrationViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) => ChangeNotifierProvider.value(
        value: viewModel,
        child: Builder(
          builder: (innerContext) => WorkTypeSelectionModal(
            workTypes: Provider.of<WorkerRegistrationViewModel>(innerContext, listen: true).workTypes,
            onToggleWorkType: viewModel.toggleWorkType,
          ),
        ),
      ),
    );
  }

  void _showCountrySelectionModal() {
    final viewModel = Provider.of<WorkerRegistrationViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) => ChangeNotifierProvider.value(
        value: viewModel,
        child: Builder(
          builder: (innerContext) => CountrySelectionModal(
            countries: Provider.of<WorkerRegistrationViewModel>(innerContext, listen: true).countries,
            onToggleCountry: viewModel.toggleCountry,
          ),
        ),
      ),
    );
  }

  void _showSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RegistrationSuccessModal(
        onOkPressed: () {
          // Close the success modal
          Navigator.of(context).pop();

          // Reset the form
          context.read<WorkerRegistrationViewModel>().resetForm();

          // Navigate back to home screen
          Navigator.of(context).pop(); // This pops the BusinessProfileListView screen itself
        },
      ),
    );
  }

  void _submitForm() async {
    // Validate the form first
    if (!_validateForm()) {
      return; // Stop if validation fails
    }

    // Update view model with form values
    widget.viewModel.updateFullName(_nameController.text);
    widget.viewModel.updatePhoneNumber(_phoneController.text);
    widget.viewModel.updateEmail(_emailController.text);
    if (_yearsController.text.isNotEmpty) {
      widget.viewModel.updateYearsOfExperience(int.tryParse(_yearsController.text) ?? 0);
    }

    final success = await widget.viewModel.submitRegistration();
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

  Color _getBorderColor(bool isDarkMode, String? errorText) {
    if (errorText != null) return Colors.red;
    return isDarkMode ? grayColor.withOpacity(0.3) : grayColor.withOpacity(0.3);
  }

  TextStyle _getHintTextStyle(bool isDarkMode) {
    return TextStyle(
      color: isDarkMode ? lightGrayColor : grayColor,
    );
  }

  TextStyle _getTextStyle(bool isDarkMode) {
    return TextStyle(
      color: isDarkMode ? lightColor : darkColor,
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
            // Form title and description
            Text(
              'Worker Registration',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? lightColor : darkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fill in your details to register as a skilled worker.',
              style: TextStyle(
                fontSize: 14,
                color: widget.isDarkMode ? lightGrayColor : grayColor,
              ),
            ),
            const SizedBox(height: 24),

            // Full Name
            _buildLabeledField('Full Name'),
            _buildTextField(
              controller: _nameController,
              hintText: 'Enter your full name',
              onChanged: (value) {
                widget.viewModel.updateFullName(value);
                _validateName(value);
              },
              errorText: _nameError,
            ),
            const SizedBox(height: 16),

            // Phone Number
            _buildLabeledField('Phone Number'),
            _buildTextField(
              controller: _phoneController,
              hintText: 'Enter your phone number',
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                widget.viewModel.updatePhoneNumber(value);
                _validatePhoneNumber(value);
              },
              errorText: _phoneError,
            ),
            const SizedBox(height: 16),

            // Email Address
            _buildLabeledField('Email Address'),
            _buildTextField(
              controller: _emailController,
              hintText: 'Enter your email address',
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                widget.viewModel.updateEmail(value);
                _validateEmail(value);
              },
              errorText: _emailError,
            ),
            const SizedBox(height: 16),

            // Work Type
            _buildLabeledField('Work Type'),
            _buildSelectionField(
              text: widget.viewModel.getSelectedWorkTypesText(),
              onTap: _showWorkTypeSelectionModal,
              errorText: _workTypeError,
            ),
            const SizedBox(height: 16),

            // Years of Experience
            _buildLabeledField('Years of Experience'),
            _buildTextField(
              controller: _yearsController,
              hintText: 'Enter years of experience',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                widget.viewModel.updateYearsOfExperience(int.tryParse(value) ?? 0);
                _validateYearsOfExperience(value);
              },
              errorText: _yearsError,
            ),
            const SizedBox(height: 16),

            // Experience Country
            _buildLabeledField('Experience Country'),
            _buildSelectionField(
              text: widget.viewModel.getSelectedCountryText(),
              onTap: _showCountrySelectionModal,
              errorText: _countryError,
            ),
            const SizedBox(height: 32),

            // Error message
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

            // Submit button
            ElevatedButton(
              onPressed: widget.viewModel.isLoading ? null : _submitForm,
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
                child: const Text(
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
    );
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
    required Function(String) onChanged,
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
              color: _getBorderColor(widget.isDarkMode, errorText),
            ),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            style: _getTextStyle(widget.isDarkMode),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: hintText,
              hintStyle: _getHintTextStyle(widget.isDarkMode),
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
                color: _getBorderColor(widget.isDarkMode, errorText),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: text.contains('e.g.') || text == 'Select Country'
                          ? _getHintTextStyle(widget.isDarkMode).color
                          : _getTextStyle(widget.isDarkMode).color,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: _getHintTextStyle(widget.isDarkMode).color,
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
