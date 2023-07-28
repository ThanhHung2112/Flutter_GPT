  import '../widgets/chat_item.dart';
  import '../widgets/my_app_bar.dart';
  import 'package:flutter/material.dart';
  import '../providers/chats_provider.dart';
  import '../widgets/text_and_voice_field.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  class ChatScreen extends StatelessWidget {
    const ChatScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: MyAppBar(
              title: "Flutter - Summarize Document", isSidebarOpen: false),
          drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              CustomDrawerHeader(),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Homepage'),
                onTap: () {
                  // TODO: Xử lý khi người dùng nhấn vào trang chủ
                },
              ),
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text('Return'),
                onTap: () {
                  // TODO: Xử lý khi người dùng nhấn vào nút quay lại
                },
              ),
              // Thêm các mục khác của sidebar tùy ý
            ],
          ),
        ),
          body: Column(
            children: [
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  final chats = ref.watch(chatsProvider).reversed.toList();
                  return ListView.builder(
                    reverse: true,
                    itemCount: chats.length,
                    itemBuilder: (context, index) => ChatItem(
                      text: chats[index].message,
                      isMe: chats[index].isMe,
                    ),
                  );
                }),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: TextAndVoiceField(
                  api: "ha",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ));
    }
  }
