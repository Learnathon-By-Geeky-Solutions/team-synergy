import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/chat/models/chat_message.dart';
import 'package:sohojogi/screens/chat/view_model/chat_view_model.dart';
import '../models/chat_conversation.dart';

class ChatListView extends StatefulWidget {
  final String conversationId;

  const ChatListView({
    super.key,
    required this.conversationId,
  });

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ChatViewModel>(context, listen: false);
      viewModel.loadMessages(widget.conversationId);
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

  PreferredSizeWidget _buildAppBar(ChatConversation conversation, bool isDarkMode) {
    return AppBar(
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
                  conversation.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDarkMode ? lightColor : darkColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  conversation.phoneNumber,
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
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe, bool showAvatar, ChatConversation conversation, bool isDarkMode) {
    final Color bubbleColor = _getBubbleColor(isMe, isDarkMode);
    final BorderRadius bubbleBorderRadius = _getBubbleBorderRadius(isMe, showAvatar);
    final Color textColor = isMe ? darkColor : lightColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) _buildAvatar(showAvatar, conversation.userImage),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _buildMessageContainer(message.text, bubbleColor, bubbleBorderRadius, textColor),
                _buildMessageMetadata(message, isMe, isDarkMode),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isMe) _buildAvatar(showAvatar, 'assets/images/user_image.png'),
        ],
      ),
    );
  }

  Color _getBubbleColor(bool isMe, bool isDarkMode) {
    return isMe
        ? primaryColor
        : isDarkMode
        ? darkColor
        : const Color(0xFF8D7B68);
  }

  BorderRadius _getBubbleBorderRadius(bool isMe, bool showAvatar) {
    return BorderRadius.only(
      topLeft: Radius.circular(isMe ? 16 : showAvatar ? 0 : 16),
      topRight: Radius.circular(isMe ? showAvatar ? 0 : 16 : 16),
      bottomLeft: const Radius.circular(16),
      bottomRight: const Radius.circular(16),
    );
  }

  Widget _buildAvatar(bool showAvatar, String imageUrl) {
    if (showAvatar) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(imageUrl),
      );
    } else {
      return const SizedBox(width: 32);
    }
  }

  Widget _buildMessageContainer(String text, Color bubbleColor, BorderRadius borderRadius, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: borderRadius,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildMessageMetadata(ChatMessage message, bool isMe, bool isDarkMode) {
    return Padding(
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
    );
  }

  Widget _buildMessageInput(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? darkColor : lightColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
            IconButton(
              icon: Icon(
                Icons.emoji_emotions_outlined,
                color: isDarkMode ? lightGrayColor : grayColor,
              ),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: isDarkMode ? grayColor.withValues(alpha: 0.2) : Colors.grey.shade200,
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
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: InkWell(
                onTap: () {
                  final viewModel = Provider.of<ChatViewModel>(context, listen: false);
                  viewModel.sendMessage(_messageController.text);
                  _messageController.clear();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                },
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final bgColor = isDarkMode ? grayColor : const Color(0xFFF9F5F0);

    return Consumer<ChatViewModel>(
      builder: (context, viewModel, child) {
        final conversation = viewModel.conversations.firstWhere(
              (c) => c.id == widget.conversationId,
          orElse: () => ChatConversation(
            id: widget.conversationId,
            userName: 'Unknown User',
            userImage: 'https://randomuser.me/api/portraits/lego/1.jpg',
            lastMessage: '',
            lastMessageTime: DateTime.now(),
            unreadCount: 0,
            phoneNumber: 'Unknown',
          ),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        return Scaffold(
          backgroundColor: bgColor,
          appBar: _buildAppBar(conversation, isDarkMode),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: viewModel.messages.length,
                  itemBuilder: (context, index) {
                    final message = viewModel.messages[index];
                    final isMe = message.senderId == viewModel.currentUserId;
                    final showAvatar = index == 0 || viewModel.messages[index - 1].senderId != message.senderId;

                    return _buildMessageBubble(message, isMe, showAvatar, conversation, isDarkMode);
                  },
                ),
              ),
              _buildMessageInput(isDarkMode),
            ],
          ),
        );
      },
    );
  }
}