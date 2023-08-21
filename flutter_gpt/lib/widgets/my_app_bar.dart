import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'theme_switch.dart';
import '../models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/active_theme_provider.dart';
import 'package:gpt_flutter/screens/home_page.dart';
import 'package:gpt_flutter/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_flutter/models/summarize_model.dart';
import 'package:gpt_flutter/screens/summarize_page.dart';
import 'package:gpt_flutter/providers/chats_provider.dart';
import 'package:gpt_flutter/services/firebase_process.dart';
import 'package:gpt_flutter/providers/global_provider.dart';
import 'package:gpt_flutter/services/view_file_firebase.dart';
import 'package:gpt_flutter/services/upload_file_firebase.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// import 'package:url_launcher/url_launcher.dart';
// import 'package:pdf/pdf.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final bool isSidebarOpen;

  const MyAppBar({required this.title, required this.isSidebarOpen, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      leading: isSidebarOpen
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(),
            )
          : IconButton(
              icon: Icon(Icons.menu_rounded),
              onPressed: () => _toggleSidebar(context),
            ),
      actions: [
        Row(
          children: [
            Consumer(
              builder: (context, ref, child) => Icon(
                ref.watch(activeThemeProvider) == Themes.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
            const SizedBox(width: 8),
            const ThemeSwitch(),
          ],
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);

  void _toggleSidebar(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
}

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(16),
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/flutter-aibot.svg', // Đường dẫn đến tệp SVG cho hình ảnh
          height: 140,
          width: 100,
        ),
      ),
    );
  }
}

class MyDrawer extends ConsumerStatefulWidget {
  MyDrawer({required this.parentContext});
  final BuildContext parentContext;
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends ConsumerState<MyDrawer> {
  // Accept the BuildContext as a parameter
  Uint8List? fileData;

  @override
  Widget build(BuildContext context) {
    final uploadAndViewFile = UploadAndViewFile();

    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                CustomDrawerHeader(),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/home.svg', // Đường dẫn đến tệp SVG cho hình ảnh
                    height: 25,
                    width: 25,
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(fontSize: 17),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                ),
                Global.chatType
                    ? ListTile(
                        leading: Image.asset(
                          'assets/images/licensing.png',
                          height: 25,
                          width: 42,
                        ),
                        title: Text(
                          'Summarize Document',
                          style: TextStyle(fontSize: 17),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SummarizeDoc(),
                            ),
                          );
                        },
                      )
                    : ListTile(
                        leading: Image.asset(
                          'assets/images/robot.png',
                          height: 25,
                          width: 52,
                        ),
                        title: Text(
                          'Chatbot',
                          style: TextStyle(fontSize: 17),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ChatScreen(isChatbot: true),
                            ),
                          );
                        },
                      ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/folder.png',
                    height: 25,
                    width: 42,
                  ),
                  title: Text(
                    'Upload File',
                    style: TextStyle(fontSize: 17),
                  ),
                  onTap: () async {
                    showProgressDialog(context, "Uploading...");
                    await uploadAndViewFile.selectFile(context);
                    Navigator.pop(context);
                    await uploadAndViewFile.readFile(context);
                    addToChatList(
                        Global.status, false, DateTime.now().toString());
                  },
                ),
                ListTile(
                    leading: SvgPicture.asset(
                      'assets/icons/view-file.svg',
                      height: 25,
                      width: 25,
                    ),
                    title: Text(
                      'View File',
                      style: TextStyle(fontSize: 17),
                    ),
                    onTap: () => uploadAndViewFile.viewFile(context)),
                ListTile(
                    leading: SvgPicture.asset(
                      'assets/icons/back.svg',
                      height: 25,
                      width: 25,
                    ),
                    title: Text(
                      'Return',
                      style: TextStyle(fontSize: 17),
                    ),
                    onTap: () {
                      print(
                          Global.chatType ? Global.chatID : Global.summarizeID);

                      firebaseProcess().deleteChatHistory("");
                      clearHistory(context);
                      Global.isFirstMessage = true;
                      if (!Global.chatType) {
                        Global.fileUploaded = false;
                      } else {}

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Global.chatType
                              ? ChatScreen(isChatbot: true)
                              : SummarizeDoc(),
                        ),
                      );
                    }
                    //
                    ),
                // Your existing ListTile widgets...
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/cancel.png',
              height: 30,
              width: 52,
            ),
            title: Text(
              'Close',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void addToChatList(String message, bool isMe, String id) {
    final chats = ref.read(summarizeProvider.notifier);
    chats.add(SummarizeModel(
      id: id,
      message: message,
      isMe: isMe,
    ));
    if (!Global.isFirstMessage) {
      firebaseProcess().sendMessageToFirebase(message, isMe, id);
    }
  }

  void clearHistory(BuildContext context) {
    Global.chatType
        ? ref.read(chatsProvider.notifier).clearChatHistory()
        : ref.read(summarizeProvider.notifier).clearSummarizeHistory();
  }
}

class EDrawer extends ConsumerStatefulWidget {
  EDrawer({required this.parentContext});
  final BuildContext parentContext;
  @override
  _EDrawerState createState() => _EDrawerState();
}

class _EDrawerState extends ConsumerState<EDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Container(
          child: Center(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text(
                    'New Chat',
                    style: TextStyle(fontSize: 18),
                  ),
                  tileColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                  onTap: () {
                    Global.chatType
                        ? Global.chatHistory = ""
                        : Global.summaryHistory = "";
                    delConversation(context,
                        Global.chatType ? Global.chatID : Global.summarizeID);
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(Global.chatType ? 'chats' : 'summaries')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    List<Widget> chatList = [];

                    snapshot.data!.docs.forEach((doc) {
                      final chatID = doc.id;
                      chatList.add(
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey[400]!, width: 1.0),
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.chat),
                            title: Text(chatID),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            trailing: GestureDetector(
                              onTap: () {
                                confirmDeleteChatHistory(context, chatID);
                              },
                              child: Icon(Icons.delete),
                            ),
                            onTap: () async {
                              Global.chatType
                                  ? Global.chatHistory = ""
                                  : Global.summaryHistory = "";
                              bool del = await clearHistory(context);
                              if (del) {
                                getChatHistoryFromFirebase(chatID);
                              }
                            },
                          ),
                        ),
                      );
                    });

                    return Expanded(
                      child: ListView(
                        children: chatList,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void delConversation(BuildContext context, String ID) {
    bool del = clearHistory(context);
    if (del) {
      Global.isFirstMessage = true;
      if (!Global.chatType) {
        Global.fileUploaded = false;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Global.chatType ? ChatScreen(isChatbot: true) : SummarizeDoc(),
        ),
      );
    }
  }

  bool clearHistory(BuildContext context) {
    Global.chatType
        ? ref.read(chatsProvider.notifier).clearChatHistory()
        : ref.read(summarizeProvider.notifier).clearSummarizeHistory();

    return true;
  }

  Future<void> confirmDeleteChatHistory(BuildContext context, String ID) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text('Delete Chats ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This will delete "$ID" ?'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.grey),
                    ),
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12), // Kích thước lớn hơn
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 16.0),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12), // Kích thước lớn hơn
                  ),
                  child: Text('Delete', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    firebaseProcess().deleteChatHistory(ID);
                    final String currentID =
                        Global.chatType ? Global.chatID : Global.summarizeID;
                    if (currentID == ID) {
                      print(currentID);
                      Global.chatType
                          ? Global.chatHistory = ""
                          : Global.summaryHistory = "";
                      bool del = clearHistory(context);
                      if (del) {
                        Global.isFirstMessage = true;
                        if (!Global.chatType) {
                          Global.fileUploaded = false;
                        }
                      }
                    }

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<List<ChatModel>> getChatHistoryFromFirebase(String ID) async {
    String collectionPath = Global.chatType ? "chats" : "summaries";
    String documentPath = "$collectionPath/$ID/chat";
    final CollectionReference chatCollection =
        FirebaseFirestore.instance.collection(documentPath);

    List<ChatModel> chatHistory = [];

    try {
      QuerySnapshot querySnapshot = await chatCollection.get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;

      for (QueryDocumentSnapshot doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        addToChatList(data['message'] ?? '', data['isMe'] ?? false, doc.id);
        if (Global.chatType) {
          Global.chatHistory = Global.chatHistory +
              (data['isMe'] ?? false ? "user: " : "you: ") +
              data['message'] +
              "\n";
        } else {
          Global.summaryHistory = Global.summaryHistory +
              (data['isMe'] ?? false ? "user: " : "you: ") +
              data['message'] +
              "\n";
          Global.currentFileName = data['filename'];
        }
      }
    } catch (error) {
      print("Error getting chat history: $error");
    }
    return chatHistory;
  }

  void addToChatList(String message, bool isMe, String id) {
    if (Global.chatType) {
      final chats = ref.read(chatsProvider.notifier);
      chats.add(ChatModel(
        id: id,
        message: message,
        isMe: isMe,
      ));
    } else {
      final chats = ref.read(summarizeProvider.notifier);
      chats.add(SummarizeModel(
        id: id,
        message: message,
        isMe: isMe,
      ));
    }
  }
}
