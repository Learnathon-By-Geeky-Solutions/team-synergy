import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/profile/view_model/profile_view_model.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  late ProfileViewModel viewModel;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    viewModel = ProfileViewModel();
  });

  group('ProfileViewModel', () {
    test('initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.hasChanges, false);
    });

    test('loadProfile for invalid user returns error', () async {
      await viewModel.loadProfile('invalid-id');
      expect(viewModel.errorMessage, isNotNull);
    });

    test('saveProfile with invalid data returns error', () async {
      viewModel.updateFullName('');
      final result = await viewModel.saveProfile('test-id');
      expect(result, false);
    });

    test('saveProfile handles error', () async {
      viewModel.updateFullName('Error Name');
      final result = await viewModel.saveProfile('test-id');
      expect(result, false);
    });
  });

}