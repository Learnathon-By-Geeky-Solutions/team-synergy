import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sohojogi/screens/worker_profile/models/worker_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/screens/worker_profile/view_model/worker_profile_view_model.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  group('WorkerProfileViewModel', () {
    late WorkerProfileViewModel viewModel;

    setUp(() {
      viewModel = WorkerProfileViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state is correct', () {
      expect(viewModel.isLoading, true);
      expect(viewModel.hasError, false);
      expect(viewModel.workerProfile, null);
      expect(viewModel.selectedServices, isEmpty);
      expect(viewModel.isBookmarked, false);
    });

    test('toggleServiceSelection updates selected services', () {
      final testService = WorkerServiceModel(
        id: 'test_id',
        name: 'Test Service',
        description: 'Test Description',
        price: 100.0,
        unit: 'hour',
      );

      expect(viewModel.selectedServices, isEmpty);
      viewModel.toggleServiceSelection(testService, true);
      expect(viewModel.selectedServices.length, 1);
      expect(viewModel.selectedServices.first.id, 'test_id');
    });

    test('toggleBookmark updates bookmark state', () {
      expect(viewModel.isBookmarked, false);

      viewModel.toggleBookmark();
      expect(viewModel.isBookmarked, true);

      viewModel.toggleBookmark();
      expect(viewModel.isBookmarked, false);
    });

    test('selectPortfolioItem updates selected index', () {
      expect(viewModel.selectedPortfolioIndex, 0);
      viewModel.selectPortfolioItem(2);
      expect(viewModel.selectedPortfolioIndex, 2);
    });
  });
}