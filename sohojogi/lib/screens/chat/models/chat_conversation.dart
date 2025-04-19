// lib/screens/chat/models/chat_conversation.dart
class ChatConversation {
  final String id;
  final String userName;
  final String userImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String phoneNumber;

  ChatConversation({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.phoneNumber,
  });
}