import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/chat/view_model/chat_view_model.dart';
import 'package:sohojogi/screens/chat/views/chat_list_view.dart';

void main() {
  group('ChatListView Tests', () {
    late ChatViewModel mockViewModel;

    setUp(() {
      mockViewModel = ChatViewModel();
    });

    testWidgets('renders correctly with messages', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider.value(
              value: mockViewModel,
              child: const ChatListView(conversationId: '1'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify AppBar elements
        expect(find.text('Metal Exchange'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.byIcon(Icons.notifications), findsOneWidget);
        expect(find.byIcon(Icons.more_vert), findsOneWidget);

        // Verify messages are displayed
        expect(find.text('Hello! How can I help you today?'), findsOneWidget);
        expect(find.text('I have a question about my recent order'), findsOneWidget);

        // Verify message input field
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byIcon(Icons.send), findsOneWidget);
      });
    });

    testWidgets('can send message', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider.value(
              value: mockViewModel,
              child: const ChatListView(conversationId: '1'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter text in message field
        await tester.enterText(find.byType(TextField), 'Test message');
        expect(find.text('Test message'), findsOneWidget);

        // Send message
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        // Verify message was sent
        expect(find.text('Test message'), findsOneWidget);

        // Wait for simulated response timer
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();
      });
    });

    testWidgets('navigates back on pressing back button', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider.value(
              value: mockViewModel,
              child: const ChatListView(conversationId: '1'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        expect(find.byType(ChatListView), findsNothing);
      });
    });

    testWidgets('handles empty message input', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider.value(
              value: mockViewModel,
              child: const ChatListView(conversationId: '1'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final initialMessageCount = mockViewModel.messages.length;

        // Try to send empty message
        await tester.enterText(find.byType(TextField), '   ');
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        // Verify no message was sent
        expect(mockViewModel.messages.length, equals(initialMessageCount));
      });
    });
  });
}