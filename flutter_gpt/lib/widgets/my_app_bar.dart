import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../providers/active_theme_provider.dart';
import 'package:gpt_flutter/screens/home_page.dart';
import 'package:gpt_flutter/screens/chat_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_flutter/models/summarize_model.dart';
import 'package:gpt_flutter/screens/summarize_page.dart';
import 'package:gpt_flutter/providers/chats_provider.dart';
import 'package:gpt_flutter/providers/global_provider.dart';
import 'package:gpt_flutter/services/view_file_firebase.dart';
import 'package:gpt_flutter/services/upload_file_firebase.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
  final String pdfFileName = 'some-file.pdf';
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
                    // showProgressDialog(context, "Processing...");

                    // await uploadAndViewFile.readFile(context);

                    // Navigator.maybePop(context);
                    

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
                    onTap: () => convertAudioToText()),
                    // uploadAndViewFile.viewFile(context)),
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
                    Navigator.pop(context);
                  },
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
  }

  
}
