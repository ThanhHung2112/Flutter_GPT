import '../widgets/chat_item.dart';
import '../widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import '../providers/chats_provider.dart';
import '../widgets/text_and_voice_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_flutter/providers/global_provider.dart';

class ChatScreen extends StatelessWidget {
  final bool isChatbot;

  const ChatScreen({required this.isChatbot});

  @override
  Widget build(BuildContext context) {
    Global.chatType = isChatbot;

    return Scaffold(
      appBar: isChatbot
          ? MyAppBar(title: "Flutter - Chatbot", isSidebarOpen: false)
          : null,
      drawer: MyDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final chatChats = ref.watch(chatsProvider).reversed.toList();
              final summarizeChats =
                  ref.watch(summarizeProvider).reversed.toList();
              return ListView.builder(
                reverse: true,
                itemCount: isChatbot ? chatChats.length : summarizeChats.length,
                itemBuilder: (context, index) => ChatItem(
                  text: isChatbot
                      ? chatChats[index].message
                      : summarizeChats[index].message,
                  isMe: isChatbot
                      ? chatChats[index].isMe
                      : summarizeChats[index].isMe,
                ),
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: TextAndVoiceField(),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
