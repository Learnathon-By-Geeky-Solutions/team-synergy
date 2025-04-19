// lib/screens/chat/models/chat_message.dart
enum MessageStatus { sent, delivered, read }

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final MessageStatus status;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.status,
  });
}