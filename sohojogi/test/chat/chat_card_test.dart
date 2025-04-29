import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/chat/models/chat_conversation.dart';
import 'package:sohojogi/screens/chat/widgets/chat_card.dart';

void main() {
  final ChatConversation testConversation = ChatConversation(
    id: '1',
    userName: 'Test User',
    userImage: 'https://randomuser.me/api/portraits/men/1.jpg',
    lastMessage: 'Hello, this is a test message',
    lastMessageTime: DateTime.now(),
    unreadCount: 3,
    phoneNumber: '+1 123-456-7890',
  );

  testWidgets('ChatCard displays conversation information correctly', (WidgetTester tester) async {
    bool tapped = false;

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChatCard(
            conversation: testConversation,
            formattedTime: '5 min',
            onTap: () {
              tapped = true;
            },
            isDarkMode: false,
          ),
        ),
      ));
    });

    // Verify username, message, time and unread count
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('Hello, this is a test message'), findsOneWidget);
    expect(find.text('5 min'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    // Test tap callback
    await tester.tap(find.byType(InkWell));
    expect(tapped, true);
  });

  testWidgets('ChatCard displays correctly in dark mode', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChatCard(
            conversation: testConversation,
            formattedTime: '5 min',
            onTap: () {},
            isDarkMode: true,
          ),
        ),
      ));
    });

    // Find the container and check background color
    final containerFinder = find.byType(Container).first;
    final Container container = tester.widget(containerFinder);
    expect(container.color, equals(darkColor));

    // Check text color in dark mode
    final userNameTextFinder = find.text('Test User');
    final Text userNameText = tester.widget(userNameTextFinder);
    expect((userNameText.style as TextStyle).color, equals(lightColor));
  });

  testWidgets('ChatCard without unread messages does not show badge', (WidgetTester tester) async {
    final conversation = ChatConversation(
      id: '1',
      userName: 'Test User',
      userImage: 'https://randomuser.me/api/portraits/men/1.jpg',
      lastMessage: 'Hello, this is a test message',
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
      phoneNumber: '+1 123-456-7890',
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChatCard(
            conversation: conversation,
            formattedTime: '5 min',
            onTap: () {},
            isDarkMode: false,
          ),
        ),
      ));
    });

    // Verify that unread count badge is not shown
    expect(find.text('0'), findsNothing);
  });

  testWidgets('ChatCard profile picture is displayed correctly', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChatCard(
            conversation: testConversation,
            formattedTime: '5 min',
            onTap: () {},
            isDarkMode: false,
          ),
        ),
      ));
    });

    // Verify CircleAvatar is present
    expect(find.byType(CircleAvatar), findsOneWidget);

    final CircleAvatar avatar = tester.widget(find.byType(CircleAvatar));
    expect(avatar.radius, 26);
    expect(avatar.backgroundImage, isA<NetworkImage>());
  });
}