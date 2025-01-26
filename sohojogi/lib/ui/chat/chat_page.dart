import 'package:flutter/material.dart';
import 'package:sohojogi/constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightColor,
      body: const Center(
        child: Text('This is the chat page'),
      ),
    );
  }
}
