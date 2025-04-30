import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sohojogi/constants/keys.dart';
import 'package:sohojogi/screens/worker_profile/views/worker_profile_list_view.dart';
import 'package:sohojogi/screens/worker_profile/view_model/worker_profile_view_model.dart';
import 'package:sohojogi/screens/order/view_model/order_view_model.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<WorkerProfileViewModel>(
            create: (_) => WorkerProfileViewModel(),
          ),
          ChangeNotifierProvider<OrderViewModel>(
            create: (_) => OrderViewModel(),
          ),
        ],
        child: WorkerProfileListView(
          workerId: 'test_id',
          onBackPressed: () {},
          onSharePressed: () {},
        ),
      ),
    );
  }

  group('WorkerProfileListView', () {
    testWidgets('renders loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading profile...'), findsOneWidget);
    });

    testWidgets('shows back button in loading state', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('shows title', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Worker Profile'), findsOneWidget);
    });

    testWidgets('shows back button in header', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      final backButton = find.byWidgetPredicate((widget) =>
      widget is Material &&
          widget.child is InkWell &&
          (widget.child as InkWell).child is Container &&
          ((widget.child as InkWell).child as Container).child is Icon &&
          (((widget.child as InkWell).child as Container).child as Icon).icon == Icons.arrow_back
      );

      expect(backButton, findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}