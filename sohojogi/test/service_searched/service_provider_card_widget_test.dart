import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/service_searched/models/service_provider_model.dart';
import 'package:sohojogi/screens/service_searched/widgets/service_provider_card_widget.dart';

void main() {
  // Sample service provider for testing
  final testProvider = ServiceProviderModel(
    id: '123',
    name: 'John Doe',
    profileImage: 'https://example.com/profile.jpg',
    location: 'Dhaka, Bangladesh',
    latitude: 23.8103,
    longitude: 90.4125,
    serviceCategory: 'Plumbing',
    email: 'john.doe@example.com',
    phoneNumber: '+880 1712345678',
    gender: Gender.male,
    rating: 4.5,
    reviewCount: 120,
    completionRate: 98.0,
    jobsCompleted: 150,
    categories: ['Plumbing', 'Repairs'],
  );

  testWidgets('ServiceProviderCardWidget displays information correctly',
          (WidgetTester tester) async {
        // Mock network images when testing
        mockNetworkImagesFor(() async {
          // Track callback invocations
          bool cardTapped = false;
          bool callTapped = false;
          bool mailTapped = false;
          bool menuTapped = false;

          // Build the widget
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ServiceProviderCardWidget(
                  serviceProvider: testProvider,
                  onCardTap: () => cardTapped = true,
                  onCallTap: () => callTapped = true,
                  onMailTap: () => mailTapped = true,
                  onMenuTap: () => menuTapped = true,
                ),
              ),
            ),
          );

          // Verify text information is displayed correctly
          expect(find.text('John Doe'), findsOneWidget);
          expect(find.text('Dhaka, Bangladesh'), findsOneWidget);
          expect(find.text('Plumbing'), findsOneWidget);
          expect(find.text('Repairs'), findsOneWidget);
          expect(find.text('john.doe@example.com'), findsOneWidget);
          expect(find.text('+880 1712345678'), findsOneWidget);
          expect(find.text('(120)'), findsOneWidget);

          // Verify action buttons
          expect(find.text('Email'), findsOneWidget);
          expect(find.text('Call'), findsOneWidget);

          // Test action button callbacks
          await tester.tap(find.text('Email'));
          expect(mailTapped, true);

          await tester.tap(find.text('Call'));
          expect(callTapped, true);

          await tester.tap(find.byIcon(Icons.more_vert));
          expect(menuTapped, true);
        });
      });

  testWidgets('ServiceProviderCardWidget adapts to dark mode',
          (WidgetTester tester) async {
        mockNetworkImagesFor(() async {
          // Build the widget with dark mode
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData.dark(),
              home: MediaQuery(
                data: const MediaQueryData(platformBrightness: Brightness.dark),
                child: Scaffold(
                  body: ServiceProviderCardWidget(
                    serviceProvider: testProvider,
                    onCardTap: () {},
                    onCallTap: () {},
                    onMailTap: () {},
                    onMenuTap: () {},
                  ),
                ),
              ),
            ),
          );

          // Verify dark mode colors
          final card = tester.widget<Card>(find.byType(Card));
          expect(card.color, darkColor);
        });
      });

  testWidgets('ServiceProviderCardWidget handles long text with ellipsis',
          (WidgetTester tester) async {
        mockNetworkImagesFor(() async {
          // Create a provider with very long text values
          final longTextProvider = ServiceProviderModel(
            id: '123',
            name: 'John Doe with a Very Long Name That Should Be Truncated',
            profileImage: 'https://example.com/profile.jpg',
            location: 'A very long location name that should definitely be truncated in the UI',
            latitude: 23.8103,
            longitude: 90.4125,
            serviceCategory: 'Plumbing',
            email: 'john.doe.with.a.very.long.email.address@verylongdomainname.example.com',
            phoneNumber: '+880 1712345678 1234567890',
            gender: Gender.male,
            rating: 4.5,
            reviewCount: 120,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ServiceProviderCardWidget(
                  serviceProvider: longTextProvider,
                  onCardTap: () {},
                  onCallTap: () {},
                  onMailTap: () {},
                  onMenuTap: () {},
                ),
              ),
            ),
          );

          // Find text widgets that should have ellipsis
          final nameText = tester.widget<Text>(find.text('John Doe with a Very Long Name That Should Be Truncated'));
          final locationText = tester.widget<Text>(find.text('A very long location name that should definitely be truncated in the UI'));
          final emailText = tester.widget<Text>(find.text('john.doe.with.a.very.long.email.address@verylongdomainname.example.com'));

          // Verify they have ellipsis set
          expect(nameText.overflow, TextOverflow.ellipsis);
          expect(locationText.overflow, TextOverflow.ellipsis);
          expect(emailText.overflow, TextOverflow.ellipsis);
        });
      });

  testWidgets('ServiceProviderCardWidget displays gender icons correctly',
          (WidgetTester tester) async {
        mockNetworkImagesFor(() async {
          // Test male gender
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ServiceProviderCardWidget(
                  serviceProvider: testProvider, // Uses Gender.male
                  onCardTap: () {},
                  onCallTap: () {},
                  onMailTap: () {},
                  onMenuTap: () {},
                ),
              ),
            ),
          );

          expect(find.byIcon(Icons.male), findsOneWidget);
          expect(find.byIcon(Icons.female), findsNothing);
          expect(find.byIcon(Icons.transgender), findsNothing);

          // Test female gender
          final femaleProvider = ServiceProviderModel(
            id: '124',
            name: 'Jane Doe',
            profileImage: 'https://example.com/profile.jpg',
            location: 'Dhaka',
            latitude: 23.8103,
            longitude: 90.4125,
            serviceCategory: 'Cleaning',
            email: 'jane@example.com',
            phoneNumber: '12345',
            gender: Gender.female,
            rating: 4.0,
            reviewCount: 10,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ServiceProviderCardWidget(
                  serviceProvider: femaleProvider,
                  onCardTap: () {},
                  onCallTap: () {},
                  onMailTap: () {},
                  onMenuTap: () {},
                ),
              ),
            ),
          );

          expect(find.byIcon(Icons.male), findsNothing);
          expect(find.byIcon(Icons.female), findsOneWidget);
          expect(find.byIcon(Icons.transgender), findsNothing);
        });
      });

  testWidgets('ServiceProviderCardWidget displays star ratings correctly',
          (WidgetTester tester) async {
        mockNetworkImagesFor(() async {
          // Test with 4.5 stars (4 full, 1 half)
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ServiceProviderCardWidget(
                  serviceProvider: testProvider, // Has rating: 4.5
                  onCardTap: () {},
                  onCallTap: () {},
                  onMailTap: () {},
                  onMenuTap: () {},
                ),
              ),
            ),
          );

          // Should have 4 full stars, 1 half star, and no empty stars
          expect(find.byIcon(Icons.star), findsNWidgets(4));
          expect(find.byIcon(Icons.star_half), findsOneWidget);
          expect(find.byIcon(Icons.star_border), findsNothing);

          // Test with 3.0 stars (3 full, 2 empty)
          final lowRatingProvider = ServiceProviderModel(
            id: '125',
            name: 'Test User',
            profileImage: 'https://example.com/profile.jpg',
            location: 'Dhaka',
            latitude: 23.8103,
            longitude: 90.4125,
            serviceCategory: 'Cleaning',
            email: 'test@example.com',
            phoneNumber: '12345',
            gender: Gender.male,
            rating: 3.0,
            reviewCount: 5,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ServiceProviderCardWidget(
                  serviceProvider: lowRatingProvider,
                  onCardTap: () {},
                  onCallTap: () {},
                  onMailTap: () {},
                  onMenuTap: () {},
                ),
              ),
            ),
          );

          // Should have 3 full stars, no half stars, and 2 empty stars
          expect(find.byIcon(Icons.star), findsNWidgets(3));
          expect(find.byIcon(Icons.star_half), findsNothing);
          expect(find.byIcon(Icons.star_border), findsNWidgets(2));
        });
      });

  testWidgets('ServiceProviderCardWidget navigates when tapped',
          (WidgetTester tester) async {
        mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ServiceProviderCardWidget(
                  serviceProvider: testProvider,
                  onCardTap: () {},
                  onCallTap: () {},
                  onMailTap: () {},
                  onMenuTap: () {},
                ),
              ),
            ),
          );

          // Note: Full navigation can't be verified without modifying widget internals
          expect(find.byType(InkWell), findsAtLeastNWidgets(1));
        });
      });
}