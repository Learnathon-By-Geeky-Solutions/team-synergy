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

    test('getWorkerReviews returns empty list for invalid worker id', () async {
      final reviews = await workerService.getWorkerReviews('invalid-id');
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
  });
}