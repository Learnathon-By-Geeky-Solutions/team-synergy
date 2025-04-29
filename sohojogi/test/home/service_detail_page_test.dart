import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/home/views/service_detail_page.dart';

void main() {
  group('ServiceDetailPage UI Tests', () {
    testWidgets('should display service name in AppBar', (WidgetTester tester) async {
      // Arrange
      const serviceName = 'Plumbing';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ServiceDetailPage(service: serviceName),
        ),
      );

      // Assert
      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      final titleFinder = find.text(serviceName);
      expect(titleFinder, findsOneWidget);

      final AppBar appBar = tester.widget<AppBar>(appBarFinder);
      expect(appBar.title, isA<Text>());
      expect((appBar.title as Text).data, serviceName);
    });

    testWidgets('should display service details text', (WidgetTester tester) async {
      // Arrange
      const serviceName = 'Plumbing';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ServiceDetailPage(service: serviceName),
        ),
      );

      // Assert
      expect(find.text('$serviceName service details'), findsOneWidget);
    });

    testWidgets('ServiceDetailPage should have a Scaffold', (WidgetTester tester) async {
      // Arrange
      const serviceName = 'Plumbing';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ServiceDetailPage(service: serviceName),
        ),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should position details text in center of screen', (WidgetTester tester) async {
      // Arrange
      const serviceName = 'Plumbing';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ServiceDetailPage(service: serviceName),
        ),
      );

      // Assert
      expect(find.byType(Center), findsOneWidget);
      final Text detailsText = tester.widget(find.text('$serviceName service details'));
      expect(tester.widget<Center>(find.byType(Center)).child, detailsText);
    });
  });
}