import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sohojogi/screens/profile/models/profile_model.dart';
import 'package:sohojogi/screens/profile/view_model/profile_edit_view_model.dart';
import 'package:sohojogi/screens/profile/views/profile_edit_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/constants/keys.dart';

class MockProfileEditViewModel extends Mock implements ProfileEditViewModel {
  @override
  bool get isLoading => false;

  @override
  ProfileModel get profileData => ProfileModel(
    id: 'test-id',
    fullName: 'Test User',
    email: 'test@example.com',
    phoneNumber: '+1234567890',
    gender: 'Male',
  );
}

void main() {
  late MockProfileEditViewModel mockViewModel;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    mockViewModel = MockProfileEditViewModel();
  });

  Widget createProfileEditView() {
    return MaterialApp(
      home: ChangeNotifierProvider<ProfileEditViewModel>.value(
        value: mockViewModel,
        child: ProfileEditView(
          onBackPressed: () {},
          profileData: ProfileModel(
            id: 'test-id',
            fullName: 'Test User',
            email: 'test@example.com',
            phoneNumber: '+1234567890',
            gender: 'Male',
          ),
        ),
      ),
    );
  }

  group('ProfileEditView Tests', () {
    testWidgets('Shows profile data when loaded', (tester) async {
      await tester.pumpWidget(createProfileEditView());
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('Save button is present', (tester) async {
      await tester.pumpWidget(createProfileEditView());
      await tester.pumpAndSettle();

      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('Shows contact information fields', (tester) async {
      await tester.pumpWidget(createProfileEditView());
      await tester.pumpAndSettle();

      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Gender'), findsOneWidget);
    });

    testWidgets('Back button works', (tester) async {
      bool backPressed = false;

      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<ProfileEditViewModel>.value(
          value: mockViewModel,
          child: ProfileEditView(
            onBackPressed: () => backPressed = true,
            profileData: ProfileModel(),
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));

      expect(backPressed, true);
    });
  });
}