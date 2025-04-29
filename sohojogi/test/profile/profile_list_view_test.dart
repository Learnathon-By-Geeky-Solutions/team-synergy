import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sohojogi/screens/profile/models/profile_model.dart';
import 'package:sohojogi/screens/profile/view_model/profile_view_model.dart';
import 'package:sohojogi/screens/profile/views/profile_list_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/constants/keys.dart';

class MockProfileViewModel extends Mock implements ProfileViewModel {
  @override
  bool get isLoading => false;

  @override
  ProfileModel get profileData => ProfileModel(
    id: 'test-id',
    fullName: 'Test User',
    email: 'test@example.com',
    phoneNumber: '+1234567890',
    gender: 'Male',
    isEmailVerified: true,
  );
}

void main() {
  late MockProfileViewModel mockViewModel;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    mockViewModel = MockProfileViewModel();
  });

  Widget createProfileListView() {
    return MaterialApp(
      home: ChangeNotifierProvider<ProfileViewModel>.value(
        value: mockViewModel,
        child: ProfileListView(
          onBackPressed: () {},
        ),
      ),
    );
  }

  group('ProfileListView Tests', () {
    testWidgets('Shows profile data when loaded', (tester) async {
      await tester.pumpWidget(createProfileListView());
      await tester.pumpAndSettle();

      // Verify header text
      expect(find.text('My Profile'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('Shows edit button', (tester) async {
      await tester.pumpWidget(createProfileListView());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('Shows contact information', (tester) async {
      await tester.pumpWidget(createProfileListView());
      await tester.pumpAndSettle();

      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('+1234567890'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
    });

    testWidgets('Shows verification status', (tester) async {
      await tester.pumpWidget(createProfileListView());
      await tester.pumpAndSettle();

      expect(find.text('Verified'), findsOneWidget);
    });

    testWidgets('Back button works', (tester) async {
      bool backPressed = false;

      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<ProfileViewModel>.value(
          value: mockViewModel,
          child: ProfileListView(
            onBackPressed: () => backPressed = true,
          ),
        ),
      ));

      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));

      expect(backPressed, true);
    });
  });
}