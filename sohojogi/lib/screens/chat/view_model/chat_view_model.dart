import 'package:flutter/material.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message.dart';

class ChatViewModel extends ChangeNotifier {
  final String _currentUserId = 'current_user';
  List<ChatConversation> _conversations = [];
  List<ChatMessage> _messages = [];
  String _activeConversationId = '';

  // Getters
  List<ChatConversation> get conversations => _conversations;
  List<ChatMessage> get messages => _messages;
  String get currentUserId => _currentUserId;

  ChatViewModel() {
    _loadConversations();
  }

  void _loadConversations() {
    // This would eventually be replaced with actual API calls
    _conversations = [
      ChatConversation(
        id: '1',
        userName: 'Metal Exchange',
        userImage: 'https://randomuser.me/api/portraits/men/32.jpg',
        lastMessage: 'Ill be there in 10 minutes',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 10)),
        unreadCount: 2,
        phoneNumber: '+43 123-456-7890',
      ),
      ChatConversation(
        id: '2',
        userName: 'Sarah Johnson',
        userImage: 'https://randomuser.me/api/portraits/women/44.jpg',
        lastMessage: 'Thanks for the info!',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 0,
        phoneNumber: '+43 987-654-3210',
      ),
      ChatConversation(
        id: '3',
        userName: 'Tech Support',
        userImage: 'https://randomuser.me/api/portraits/men/59.jpg',
        lastMessage: 'Your ticket has been resolved',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 1,
        phoneNumber: '+43 555-789-1234',
      ),
      // Add other conversations from inbox_list_view.dart
    ];
    notifyListeners();
  }

  void loadMessages(String conversationId) {
    _activeConversationId = conversationId;

    // This would eventually be replaced with actual API calls
    _messages = [
      ChatMessage(
        id: '1',
        senderId: conversationId,
        text: 'Hello! How can I help you today?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '2',
        senderId: _currentUserId,
        text: 'I have a question about my recent order',
        timestamp: DateTime.now().subtract(const Duration(minutes: 32)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '3',
        senderId: conversationId,
        text: 'Sure, I can help with that. Could you provide your order number?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '4',
        senderId: _currentUserId,
        text: 'It\'s #ORD-12345',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '5',
        senderId: conversationId,
        text: 'Thank you! Let me check the status for you.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 23)),
        status: MessageStatus.read,
      ),
      // Add other messages from chat_list_view.dart
    ];
    notifyListeners();
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _currentUserId,
      text: text.trim(),
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    _messages.add(newMessage);

    // Update the conversation list with the last message
    final index = _conversations.indexWhere((c) => c.id == _activeConversationId);
    if (index != -1) {
      final conversation = _conversations[index];
      _conversations[index] = ChatConversation(
        id: conversation.id,
        userName: conversation.userName,
        userImage: conversation.userImage,
        lastMessage: text.trim(),
        lastMessageTime: DateTime.now(),
        unreadCount: conversation.unreadCount,
        phoneNumber: conversation.phoneNumber,
      );
    }

    notifyListeners();

    // Simulate received message for demo purposes
    _simulateResponse();
  }

  void _simulateResponse() {
    if (_messages.length % 2 == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: _activeConversationId,
          text: "Thanks for your message! I'll respond shortly.",
          timestamp: DateTime.now(),
          status: MessageStatus.delivered,
        ));
        notifyListeners();
      });
    }
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}