import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/home/views/service_detail_page.dart';

void main() {
  testWidgets('ServiceDetailPage renders correctly', (WidgetTester tester) async {
    const testServiceName = 'Plumber';

    await tester.pumpWidget(
      const MaterialApp(
        home: ServiceDetailPage(service: testServiceName),
      ),
    );

    expect(find.text(testServiceName), findsOneWidget);
    expect(find.text('$testServiceName service details'), findsOneWidget);
  });

  testWidgets('ServiceDetailPage handles different service names', (WidgetTester tester) async {
    const testServiceName = 'Electrician';

    await tester.pumpWidget(
      const MaterialApp(
        home: ServiceDetailPage(service: testServiceName),
      ),
    );

    // Check if the app bar title shows the service name
    expect(find.text(testServiceName), findsOneWidget);

    // Check if the service details message is shown
    expect(find.text('$testServiceName service details'), findsOneWidget);
  });

  testWidgets('ServiceDetailPage renders with long service name', (WidgetTester tester) async {
    const longServiceName = 'Professional House Cleaning and Organization Expert';

    await tester.pumpWidget(
      const MaterialApp(
        home: ServiceDetailPage(service: longServiceName),
      ),
    );

    // Check if the app bar title shows the service name
    expect(find.text(longServiceName), findsOneWidget);

    // Check if the service details message is shown
    expect(find.text('$longServiceName service details'), findsOneWidget);
  });

  testWidgets('ServiceDetailPage scaffold contains expected structure', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ServiceDetailPage(service: 'Test Service'),
      ),
    );

    // Check for scaffold components
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
    
    // Check for correct text
    expect(find.text('Test Service'), findsOneWidget);
    expect(find.text('Test Service service details'), findsOneWidget);
  });
}