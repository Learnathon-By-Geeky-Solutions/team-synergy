// lib/screens/chat/views/chat_list_view.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/chat/models/chat_conversation.dart';
import 'package:sohojogi/screens/chat/models/chat_message.dart';

class ChatListView extends StatefulWidget {
  final ChatConversation conversation;

  const ChatListView({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String _currentUserId = 'current_user'; // Hardcoded for demo
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    // Initialize with dummy message data
    _messages = [
      ChatMessage(
        id: '1',
        senderId: widget.conversation.id,
        text: 'Hello! How can I help you today?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '2',
        senderId: _currentUserId,
        text: 'I need help with my plumbing issue. When can you come over?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '3',
        senderId: widget.conversation.id,
        text: 'I can come tomorrow between 9 AM and 12 PM. Would that work for you?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '4',
        senderId: _currentUserId,
        text: 'Yes, that works perfectly. Thank you!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '5',
        senderId: widget.conversation.id,
        text: "Great! I'll be there. Please make sure someone is home to let me in.",
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '6',
        senderId: _currentUserId,
        text: "I'll be home. My address is 123 Main Street, Apartment 4B.",
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '7',
        senderId: widget.conversation.id,
        text: "I'll be there in 10 minutes",
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        status: MessageStatus.delivered,
      ),
    ];

    // Scroll to the bottom after rendering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _currentUserId,
      text: _messageController.text.trim(),
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Scroll to the bottom after adding a new message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Simulate received message (for demo purposes only)
    if (_messages.length % 2 == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _messages.add(ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              senderId: widget.conversation.id,
              text: "Thanks for your message! I'll respond shortly.",
              timestamp: DateTime.now(),
              status: MessageStatus.delivered,
            ));
          });

          _scrollToBottom();
        }
      });
    }
  }

  String _formatMessageTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildMessageStatus(MessageStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case MessageStatus.sent:
        icon = Icons.check;
        color = Colors.grey;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = Colors.grey;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = Colors.blue;
        break;
    }

    return Icon(icon, size: 14, color: color);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final bgColor = isDarkMode ? grayColor : const Color(0xFFF9F5F0); // Light cream/beige

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? darkColor : lightColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: isDarkMode ? lightColor : darkColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDarkMode ? lightColor : darkColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.conversation.phoneNumber,
                    style: const TextStyle(
                      fontSize: 12,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: isDarkMode ? lightColor : darkColor,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: isDarkMode ? lightColor : darkColor,
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId == _currentUserId;
                final showAvatar = index == 0 || _messages[index - 1].senderId != message.senderId;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Other user's avatar
                      if (!isMe && showAvatar)
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(widget.conversation.userImage),
                        )
                      else if (!isMe && !showAvatar)
                        const SizedBox(width: 32), // Space for alignment when no avatar

                      const SizedBox(width: 8),

                      // Message bubble
                      Flexible(
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? primaryColor // Yellow/gold for current user
                                    : isDarkMode
                                    ? darkColor
                                    : const Color(0xFF8D7B68), // Brown/copper for other user
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(isMe ? 16 : showAvatar ? 0 : 16),
                                  topRight: Radius.circular(isMe ? showAvatar ? 0 : 16 : 16),
                                  bottomLeft: const Radius.circular(16),
                                  bottomRight: const Radius.circular(16),
                                ),
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: isMe ? darkColor : lightColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),

                            // Time and status
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _formatMessageTime(message.timestamp),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDarkMode ? lightGrayColor : grayColor,
                                    ),
                                  ),
                                  if (isMe) ...[
                                    const SizedBox(width: 4),
                                    _buildMessageStatus(message.status),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Current user's avatar
                      if (isMe && showAvatar)
                        const CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage('assets/images/user_image.png'),
                        )
                      else if (isMe && !showAvatar)
                        const SizedBox(width: 32), // Space for alignment when no avatar
                    ],
                  ),
                );
              },
            ),
          ),

          // Message Input
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? darkColor : lightColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Emoji button
                  IconButton(
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: isDarkMode ? lightGrayColor : grayColor,
                    ),
                    onPressed: () {},
                  ),

                  // Text input field
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: isDarkMode ? grayColor.withOpacity(0.2) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(
                          color: isDarkMode ? lightColor : darkColor,
                        ),
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Type message here...',
                          hintStyle: TextStyle(
                            color: isDarkMode ? lightGrayColor : grayColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Send button
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: InkWell(
                      onTap: _sendMessage,
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: 46,
                        width: 46,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send,
                          color: lightColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}