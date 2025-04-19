// lib/screens/business_profile/models/worker_registration_model.dart
class WorkerRegistrationModel {
  String fullName;
  String phoneNumber;
  String email;
  List<WorkTypeModel> selectedWorkTypes;
  int yearsOfExperience;
  String experienceCountry;

  WorkerRegistrationModel({
    this.fullName = '',
    this.phoneNumber = '',
    this.email = '',
    this.selectedWorkTypes = const [],
    this.yearsOfExperience = 0,
    this.experienceCountry = '',
  });

  bool get isValid {
    return fullName.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        email.isNotEmpty &&
        selectedWorkTypes.isNotEmpty &&
        yearsOfExperience > 0 &&
        experienceCountry.isNotEmpty;
  }
}

class WorkTypeModel {
  final String id;
  final String name;
  final String icon;
  bool isSelected;

  WorkTypeModel({
    required this.id,
    required this.name,
    required this.icon,
    this.isSelected = false,
  });
}

class CountryModel {
  final String id;
  final String name;
  final String flag;
  bool isSelected;

  CountryModel({
    required this.id,
    required this.name,
    required this.flag,
    this.isSelected = false,
  });
}