import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/business_profile/models/worker_registration_model.dart';

void main() {
  group('WorkerRegistrationModel', () {
    test('should initialize with empty values', () {
      final model = WorkerRegistrationModel();

      expect(model.fullName, '');
      expect(model.phoneNumber, '');
      expect(model.email, '');
      expect(model.yearsOfExperience, 0);
      expect(model.experienceCountry, '');
      expect(model.selectedWorkTypes, isEmpty);
      expect(model.isValid, false);
    });

    test('should update properties correctly', () {
      final model = WorkerRegistrationModel();

      model.fullName = 'John Doe';
      model.phoneNumber = '+1234567890';
      model.email = 'john@example.com';
      model.yearsOfExperience = 5;
      model.experienceCountry = 'United States';

      expect(model.fullName, 'John Doe');
      expect(model.phoneNumber, '+1234567890');
      expect(model.email, 'john@example.com');
      expect(model.yearsOfExperience, 5);
      expect(model.experienceCountry, 'United States');
    });

    test('should not be valid when required fields are missing', () {
      final model = WorkerRegistrationModel();
      expect(model.isValid, false);

      // Test with only some fields filled
      model.fullName = 'John Doe';
      expect(model.isValid, false);

      model.phoneNumber = '+1234567890';
      expect(model.isValid, false);

      model.email = 'john@example.com';
      expect(model.isValid, false);

      model.yearsOfExperience = 5;
      expect(model.isValid, false);

      model.experienceCountry = 'United States';
      // Still not valid without work types
      expect(model.isValid, false);
    });

    test('should be valid when all required fields are filled', () {
      final model = WorkerRegistrationModel();

      model.fullName = 'John Doe';
      model.phoneNumber = '+1234567890';
      model.email = 'john@example.com';
      model.yearsOfExperience = 5;
      model.experienceCountry = 'United States';

      // Add a work type
      model.selectedWorkTypes = [
        WorkTypeModel(id: '1', name: 'Plumber', icon: 'icon_path')
      ];

      expect(model.isValid, true);
    });

    test('should handle selected work types correctly', () {
      final model = WorkerRegistrationModel();
      expect(model.selectedWorkTypes, isEmpty);

      final workType1 = WorkTypeModel(id: '1', name: 'Plumber', icon: 'icon_path');
      final workType2 = WorkTypeModel(id: '2', name: 'Electrician', icon: 'icon_path');

      model.selectedWorkTypes = [workType1];
      expect(model.selectedWorkTypes.length, 1);
      expect(model.selectedWorkTypes.first.name, 'Plumber');

      model.selectedWorkTypes = [workType1, workType2];
      expect(model.selectedWorkTypes.length, 2);
      expect(model.selectedWorkTypes[1].name, 'Electrician');

      model.selectedWorkTypes = [];
      expect(model.selectedWorkTypes, isEmpty);
    });
  });

  group('WorkTypeModel', () {
    test('should initialize with provided values', () {
      final workType = WorkTypeModel(
          id: '1',
          name: 'Plumber',
          icon: 'icon_path',
          isSelected: true
      );

      expect(workType.id, '1');
      expect(workType.name, 'Plumber');
      expect(workType.icon, 'icon_path');
      expect(workType.isSelected, true);
    });

    test('should initialize with default isSelected value', () {
      final workType = WorkTypeModel(
          id: '1',
          name: 'Plumber',
          icon: 'icon_path'
      );

      expect(workType.isSelected, false);
    });
  });

  group('CountryModel', () {
    test('should initialize with provided values', () {
      final country = CountryModel(
          id: '1',
          name: 'United States',
          flag: '🇺🇸',
          isSelected: true
      );

      expect(country.id, '1');
      expect(country.name, 'United States');
      expect(country.flag, '🇺🇸');
      expect(country.isSelected, true);
    });

    test('should initialize with default isSelected value', () {
      final country = CountryModel(
          id: '1',
          name: 'United States',
          flag: '🇺🇸'
      );

      expect(country.isSelected, false);
    });
  });
}