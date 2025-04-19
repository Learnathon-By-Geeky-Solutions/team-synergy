// lib/screens/chat/views/inbox_list_view.dart
import 'package:flutter/material.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/chat/models/chat_conversation.dart';
import 'package:sohojogi/screens/chat/views/chat_list_view.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';

class InboxListView extends StatefulWidget {
  const InboxListView({super.key});

  @override
  State<InboxListView> createState() => _InboxListViewState();
}

class _InboxListViewState extends State<InboxListView> {
  late List<ChatConversation> _conversations;

  @override
  void initState() {
    super.initState();
    // Initialize with dummy conversation data
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
    userName: 'Michael Tony',
    userImage: 'https://randomuser.me/api/portraits/men/41.jpg',
    lastMessage: 'Please confirm your appointment for tomorrow',
    lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
    unreadCount: 1,
    phoneNumber: '+43 987-654-3210',
    ),
    ChatConversation(
    id: '3',
    userName: 'Sarah Johnson',
    userImage: 'https://randomuser.me/api/portraits/women/44.jpg',
    lastMessage: 'The repair is complete, thank you!',
    lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
    unreadCount: 0,
    phoneNumber: '+43 555-123-4567',
    ),
    ChatConversation(
    id: '4',
    userName: 'Plumbing Service',
    userImage: 'https://randomuser.me/api/portraits/men/56.jpg',
    lastMessage: 'Well arrive between 2-4 PM tomorrow',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
    unreadCount: 0,
    phoneNumber: '+43 444-333-2222',
    ),
    ChatConversation(
    id: '5',
    userName: 'Emma Wilson',
    userImage: 'https://randomuser.me/api/portraits/women/33.jpg',
    lastMessage: 'Thank you for the excellent service!',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
    unreadCount: 0,
    phoneNumber: '+43 111-222-3333',
    ),
    ];
  }

  String _formatTime(DateTime time) {
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

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final bgColor = isDarkMode ? grayColor : const Color(0xFFF9F5F0); // Light cream/beige

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? darkColor : lightColor,
        centerTitle: true,
        title: Text(
          'Chat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? lightColor : darkColor,
          ),
        ),
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: _conversations.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: isDarkMode ? darkColor.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
          indent: 76,
        ),
        itemBuilder: (context, index) {
          final conversation = _conversations[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatListView(conversation: conversation),
                ),
              );
            },
            child: Container(
              color: isDarkMode ? darkColor : lightColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(conversation.userImage),
                  ),
                  const SizedBox(width: 12),

                  // Message Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                conversation.userName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDarkMode ? lightColor : darkColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              _formatTime(conversation.lastMessageTime),
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode ? lightGrayColor : grayColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                conversation.lastMessage,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode ? lightGrayColor : grayColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (conversation.unreadCount > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${conversation.unreadCount}',
                                  style: const TextStyle(
                                    color: lightColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const AppNavBar(),
    );
  }
}