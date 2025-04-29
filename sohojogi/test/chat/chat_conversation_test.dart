import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/chat/models/chat_conversation.dart';

void main() {
  group('ChatConversation', () {
    // Test data
    final String id = 'test-id';
    final String userName = 'Test User';
    final String userImage = 'https://example.com/image.jpg';
    final String lastMessage = 'Hello, this is a test message';
    final DateTime lastMessageTime = DateTime(2023, 1, 1, 12, 0);
    final int unreadCount = 5;
    final String phoneNumber = '+1 234-567-8901';

    test('should create ChatConversation with correct properties', () {
      // Act
      final conversation = ChatConversation(
        id: id,
        userName: userName,
        userImage: userImage,
        lastMessage: lastMessage,
        lastMessageTime: lastMessageTime,
        unreadCount: unreadCount,
        phoneNumber: phoneNumber,
      );

      // Assert
      expect(conversation.id, equals(id));
      expect(conversation.userName, equals(userName));
      expect(conversation.userImage, equals(userImage));
      expect(conversation.lastMessage, equals(lastMessage));
      expect(conversation.lastMessageTime, equals(lastMessageTime));
      expect(conversation.unreadCount, equals(unreadCount));
      expect(conversation.phoneNumber, equals(phoneNumber));
    });

    test('should handle empty values correctly', () {
      final conversation = ChatConversation(
        id: '',
        userName: '',
        userImage: '',
        lastMessage: '',
        lastMessageTime: DateTime(0),
        unreadCount: 0,
        phoneNumber: '',
      );

      expect(conversation.id, equals(''));
      expect(conversation.userName, equals(''));
      expect(conversation.userImage, equals(''));
      expect(conversation.lastMessage, equals(''));
      expect(conversation.lastMessageTime, equals(DateTime(0)));
      expect(conversation.unreadCount, equals(0));
      expect(conversation.phoneNumber, equals(''));
    });

    test('should handle large values correctly', () {
      final String longText = 'a' * 1000;
      final conversation = ChatConversation(
        id: longText,
        userName: longText,
        userImage: longText,
        lastMessage: longText,
        lastMessageTime: DateTime(9999, 12, 31),
        unreadCount: 999999,
        phoneNumber: longText,
      );

      expect(conversation.id, equals(longText));
      expect(conversation.userName, equals(longText));
      expect(conversation.userImage, equals(longText));
      expect(conversation.lastMessage, equals(longText));
      expect(conversation.lastMessageTime, equals(DateTime(9999, 12, 31)));
      expect(conversation.unreadCount, equals(999999));
      expect(conversation.phoneNumber, equals(longText));
    });
  });
}