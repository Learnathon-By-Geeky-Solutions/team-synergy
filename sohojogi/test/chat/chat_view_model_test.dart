import 'package:flutter_test/flutter_test.dart';
import 'package:sohojogi/screens/chat/models/chat_message.dart';
import 'package:sohojogi/screens/chat/view_model/chat_view_model.dart';

void main() {
  late ChatViewModel viewModel;

  setUp(() {
    viewModel = ChatViewModel();
  });

  group('ChatViewModel initialization', () {
    test('should initialize with conversations loaded', () {
      // Assert
      expect(viewModel.conversations, isNotEmpty);
      expect(viewModel.conversations.length, 3); // Based on the mock data
      expect(viewModel.conversations.first.userName, 'Metal Exchange');
    });

    test('should have current user ID set', () {
      expect(viewModel.currentUserId, 'current_user');
    });
  });

  group('ChatViewModel loadMessages', () {
    test('should load messages for a specific conversation', () {
      // Act
      viewModel.loadMessages('1');

      // Assert
      expect(viewModel.messages, isNotEmpty);
      expect(viewModel.messages.length, 5); // Based on the mock data
      expect(viewModel.messages.first.senderId, '1');
      expect(viewModel.messages.first.text, 'Hello! How can I help you today?');
    });
  });

  group('ChatViewModel sendMessage', () {
    test('should add message to messages list', () {
      // Arrange
      viewModel.loadMessages('1');
      final initialMessagesCount = viewModel.messages.length;

      // Act
      viewModel.sendMessage('Test message');

      // Assert
      expect(viewModel.messages.length, initialMessagesCount + 1);
      expect(viewModel.messages.last.text, 'Test message');
      expect(viewModel.messages.last.senderId, 'current_user');
      expect(viewModel.messages.last.status, MessageStatus.sent);
    });

    test('should update conversation with new last message', () {
      // Arrange
      viewModel.loadMessages('1');

      // Act
      viewModel.sendMessage('New last message');

      // Assert
      final updatedConversation = viewModel.conversations.firstWhere((c) => c.id == '1');
      expect(updatedConversation.lastMessage, 'New last message');
    });

    test('should not add empty message', () {
      // Arrange
      viewModel.loadMessages('1');
      final initialMessagesCount = viewModel.messages.length;

      // Act
      viewModel.sendMessage('   ');

      // Assert
      expect(viewModel.messages.length, initialMessagesCount);
    });
  });

  group('ChatViewModel formatTime', () {
    test('should format time in minutes when less than an hour', () {
      // Arrange
      final now = DateTime.now();
      final timeToFormat = now.subtract(const Duration(minutes: 30));

      // Act
      final result = viewModel.formatTime(timeToFormat);

      // Assert
      expect(result, '30 min');
    });

    test('should format time in hours when less than a day', () {
      // Arrange
      final now = DateTime.now();
      final timeToFormat = now.subtract(const Duration(hours: 5));

      // Act
      final result = viewModel.formatTime(timeToFormat);

      // Assert
      expect(result, '5 hr');
    });

    test('should format time in days when less than a week', () {
      // Arrange
      final now = DateTime.now();
      final timeToFormat = now.subtract(const Duration(days: 3));

      // Act
      final result = viewModel.formatTime(timeToFormat);

      // Assert
      expect(result, '3 days');
    });

    test('should format time as date when more than a week', () {
      // Arrange
      final timeToFormat = DateTime(2023, 5, 10);

      // Act
      final result = viewModel.formatTime(timeToFormat);

      // Assert
      expect(result, '10/5/2023');
    });
  });

  group('ChatViewModel simulation response', () {
    test('should simulate response after sending a message', () async {
      // Arrange
      viewModel.loadMessages('1');
      final int initialCount = viewModel.messages.length;

      // Act - Send one message when count is odd (to make it even and trigger response)
      viewModel.sendMessage('Test message');

      // Wait for the simulated response
      await Future.delayed(const Duration(seconds: 3));

      // Assert
      expect(viewModel.messages.length, initialCount + 2); // Original message + simulated response
      expect(viewModel.messages[viewModel.messages.length - 1].senderId, isNot('current_user'));
      expect(viewModel.messages[viewModel.messages.length - 1].text, contains("Thanks for your message"));
    });
  });

  group('ChatViewModel edge cases', () {
    test('should handle loading messages for non-existent conversation', () {
      // Act
      viewModel.loadMessages('non-existent-id');

      // Assert - should not throw and should have messages
      expect(viewModel.messages, isNotEmpty);
    });

    test('should handle multiple message sending in quick succession', () {
      // Arrange
      viewModel.loadMessages('1');

      // Act
      viewModel.sendMessage('Message 1');
      viewModel.sendMessage('Message 2');
      viewModel.sendMessage('Message 3');

      // Assert
      expect(viewModel.messages.where((m) => m.text == 'Message 1').length, 1);
      expect(viewModel.messages.where((m) => m.text == 'Message 2').length, 1);
      expect(viewModel.messages.where((m) => m.text == 'Message 3').length, 1);
    });
  });
}