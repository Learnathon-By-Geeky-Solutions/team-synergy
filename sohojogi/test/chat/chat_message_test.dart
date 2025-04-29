import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/chat/models/chat_message.dart';

void main() {
  group('ChatMessage', () {
    // Test data
    final String id = 'msg-123';
    final String senderId = 'user-456';
    final String text = 'Hello, this is a test message';
    final DateTime timestamp = DateTime(2023, 1, 1, 12, 0);
    final MessageStatus status = MessageStatus.delivered;

    test('should create ChatMessage with correct properties', () {
      // Act
      final message = ChatMessage(
        id: id,
        senderId: senderId,
        text: text,
        timestamp: timestamp,
        status: status,
      );

      // Assert
      expect(message.id, equals(id));
      expect(message.senderId, equals(senderId));
      expect(message.text, equals(text));
      expect(message.timestamp, equals(timestamp));
      expect(message.status, equals(status));
    });

    test('should handle all MessageStatus values correctly', () {
      final sentMessage = ChatMessage(
        id: id,
        senderId: senderId,
        text: text,
        timestamp: timestamp,
        status: MessageStatus.sent,
      );

      final deliveredMessage = ChatMessage(
        id: id,
        senderId: senderId,
        text: text,
        timestamp: timestamp,
        status: MessageStatus.delivered,
      );

      final readMessage = ChatMessage(
        id: id,
        senderId: senderId,
        text: text,
        timestamp: timestamp,
        status: MessageStatus.read,
      );

      expect(sentMessage.status, equals(MessageStatus.sent));
      expect(deliveredMessage.status, equals(MessageStatus.delivered));
      expect(readMessage.status, equals(MessageStatus.read));
    });

    test('should handle empty values correctly', () {
      final message = ChatMessage(
        id: '',
        senderId: '',
        text: '',
        timestamp: DateTime(0),
        status: MessageStatus.sent,
      );

      expect(message.id, equals(''));
      expect(message.senderId, equals(''));
      expect(message.text, equals(''));
      expect(message.timestamp, equals(DateTime(0)));
      expect(message.status, equals(MessageStatus.sent));
    });

    test('should handle large values correctly', () {
      final String longText = 'a' * 1000;
      final message = ChatMessage(
        id: longText,
        senderId: longText,
        text: longText,
        timestamp: DateTime(9999, 12, 31),
        status: MessageStatus.read,
      );

      expect(message.id, equals(longText));
      expect(message.senderId, equals(longText));
      expect(message.text, equals(longText));
      expect(message.timestamp, equals(DateTime(9999, 12, 31)));
      expect(message.status, equals(MessageStatus.read));
    });
  });
}