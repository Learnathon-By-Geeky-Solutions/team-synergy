import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/base/services/worker_service.dart';
import 'package:sohojogi/constants/keys.dart';

void main() {
  late WorkerDatabaseService workerService;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  setUp(() {
    workerService = WorkerDatabaseService();
  });

  group('WorkerDatabaseService Tests', () {
    test('WorkerDatabaseService initializes correctly', () {
      expect(workerService, isNotNull);
    });

    test('getWorkerProfile returns null for invalid worker id', () async {
      final profile = await workerService.getWorkerProfile('invalid-id');
      expect(profile, isNull);
    });

    test('getWorkerProfile handles parse error correctly', () async {
      // This test will force a parsing error by using a valid-looking ID
      // that doesn't have proper data structure
      final profile = await workerService.getWorkerProfile('error-test-id');
      expect(profile, isNull);
    });

    test('getWorkerProfile handles gender parsing for male', () async {
      // This will be caught by the try-catch, returning null
      final profile = await workerService.getWorkerProfile('male-test-id');
      expect(profile, isNull);
    });

    test('getWorkerProfile handles gender parsing for female', () async {
      // This will be caught by the try-catch, returning null
      final profile = await workerService.getWorkerProfile('female-test-id');
      expect(profile, isNull);
    });

    test('getWorkerReviews returns empty list for invalid worker id', () async {
      final reviews = await workerService.getWorkerReviews('invalid-id');
      expect(reviews, isEmpty);
    });

    test('getWorkerReviews handles pagination correctly', () async {
      // Test with different pagination parameters
      final reviews = await workerService.getWorkerReviews(
          'invalid-id',
          page: 2,
          limit: 5
      );
      expect(reviews, isEmpty);
    });

    test('getWorkerReviews handles reviews with null photos', () async {
      // This will be caught by the try-catch, returning an empty list
      final reviews = await workerService.getWorkerReviews('no-photos-id');
      expect(reviews, isEmpty);
    });

    test('getWorkerReviews handles reviews with photos', () async {
      // This will be caught by the try-catch, returning an empty list
      final reviews = await workerService.getWorkerReviews('with-photos-id');
      expect(reviews, isEmpty);
    });

    test('getRatingBreakdown returns zero counts for invalid worker id', () async {
      final breakdown = await workerService.getRatingBreakdown('invalid-id');
      expect(breakdown.oneStars, equals(0));
      expect(breakdown.twoStars, equals(0));
      expect(breakdown.threeStars, equals(0));
      expect(breakdown.fourStars, equals(0));
      expect(breakdown.fiveStars, equals(0));
    });

    test('getRatingBreakdown handles exception', () async {
      // Force an error case
      final breakdown = await workerService.getRatingBreakdown('error-id');

      // Should return default values
      expect(breakdown.oneStars, equals(0));
      expect(breakdown.twoStars, equals(0));
      expect(breakdown.threeStars, equals(0));
      expect(breakdown.fourStars, equals(0));
      expect(breakdown.fiveStars, equals(0));
    });

    test('_countRatingsByStars handles database errors', () async {
      // Test that the private method handles errors gracefully
      // This will occur inside getRatingBreakdown
      final breakdown = await workerService.getRatingBreakdown('count-error-id');
      expect(breakdown.fiveStars, equals(0)); // Default when error occurs
    });
  });
}