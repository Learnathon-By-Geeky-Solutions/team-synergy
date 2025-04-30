import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:sohojogi/screens/chat/views/chat_list_view.dart';
import 'package:sohojogi/screens/chat/views/inbox_list_view.dart';

void main() {
  group('InboxListView Tests', () {
    testWidgets('renders correctly with conversations', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: InboxListView()));
        await tester.pumpAndSettle();

        // Verify AppBar
        expect(find.text('Chat'), findsOneWidget);

        // Verify conversations are displayed
        expect(find.text('Metal Exchange'), findsOneWidget);
        expect(find.text('Sarah Johnson'), findsOneWidget);
        expect(find.text('Tech Support'), findsOneWidget);

        // Verify last messages
        expect(find.text('Ill be there in 10 minutes'), findsOneWidget);
        expect(find.text('Thanks for the info!'), findsOneWidget);
        expect(find.text('Your ticket has been resolved'), findsOneWidget);
      });
    });

    testWidgets('navigates to chat view on tap', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: InboxListView()));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Metal Exchange'));
        await tester.pumpAndSettle();

        // Verify navigation to ChatListView
        expect(find.byType(ChatListView), findsOneWidget);
      });
    });
  });
}