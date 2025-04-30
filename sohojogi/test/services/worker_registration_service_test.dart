import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/base/services/worker_registration_service.dart';
import 'package:sohojogi/constants/keys.dart';
import 'package:sohojogi/screens/business_profile/models/worker_registration_model.dart';

void main() {
  late WorkerRegistrationService registrationService;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    registrationService = WorkerRegistrationService();
  });

  group('WorkerRegistrationService Tests', () {
    test('WorkerRegistrationService initializes correctly', () {
      expect(registrationService, isNotNull);
    });

    test('getWorkTypes returns list of work types', () async {
      final workTypes = await registrationService.getWorkTypes();
      expect(workTypes, isA<List>());
    });

    test('getCountries returns list of countries', () async {
      final countries = await registrationService.getCountries();
      expect(countries, isA<List>());
    });

    test('registerWorker throws error for invalid data', () async {
      final worker = WorkerRegistrationModel(
        fullName: '',
        phoneNumber: '',
        email: 'invalid-email',
        yearsOfExperience: -1,
        experienceCountry: '',
        selectedWorkTypes: [],
      );

      expect(
            () => registrationService.registerWorker(worker),
        throwsException,
      );
    });
  });
}