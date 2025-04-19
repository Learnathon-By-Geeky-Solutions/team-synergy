import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/chat/view_model/chat_view_model.dart';
import 'package:sohojogi/screens/chat/views/chat_list_view.dart';
import 'package:sohojogi/screens/chat/widgets/chat_card.dart';
import 'package:sohojogi/screens/navigation/app_navbar.dart';

class InboxListView extends StatelessWidget {
  const InboxListView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final bgColor = isDarkMode ? grayColor : const Color(0xFFF9F5F0);

    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(),
      child: Scaffold(
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
        body: Consumer<ChatViewModel>(
          builder: (context, viewModel, child) {
            final conversations = viewModel.conversations;

            return ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: isDarkMode ? darkColor.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                indent: 76,
              ),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final formattedTime = viewModel.formatTime(conversation.lastMessageTime);

                return ChatCard(
                  conversation: conversation,
                  formattedTime: formattedTime,
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: viewModel, // Pass the existing instance
                          child: ChatListView(conversationId: conversation.id),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        bottomNavigationBar: const AppNavBar(currentIndex: 2),
      ),
    );
  }
}