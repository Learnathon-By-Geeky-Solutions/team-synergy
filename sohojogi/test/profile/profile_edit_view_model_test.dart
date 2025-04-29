import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/base/services/profile_service.dart';
import 'package:sohojogi/screens/profile/models/profile_model.dart';
import 'package:sohojogi/screens/profile/view_model/profile_edit_view_model.dart';
import 'package:sohojogi/constants/keys.dart';

class MockProfileService extends Mock implements ProfileService {}

void main() {
  late ProfileEditViewModel viewModel;
  late MockProfileService mockProfileService;
  late ProfileModel initialData;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    mockProfileService = MockProfileService();
    initialData = ProfileModel(
      id: 'test-id',
      fullName: 'Test User',
      email: 'test@example.com',
      phoneNumber: '+1234567890',
      gender: 'Male',
      isEmailVerified: false,
    );
    viewModel = ProfileEditViewModel(
      initialData: initialData,
      profileService: mockProfileService,
    );
  });

  group('ProfileEditViewModel', () {
    test('initial state is correct', () {
      expect(viewModel.profileData.fullName, 'Test User');
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.hasChanges, false);
    });

    test('field updates trigger hasChanges', () {
      viewModel.updateFullName('New Name');
      expect(viewModel.hasChanges, true);
      expect(viewModel.profileData.fullName, 'New Name');
    });

    test('saveProfile with invalid name returns error', () async {
      viewModel.updateFullName('');
      final result = await viewModel.saveProfile('test-id');
      expect(result, false);
      expect(viewModel.errorMessage, 'Please fill all required fields');
    });
  });
}