import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gpt_flutter/widgets/my_app_bar.dart';
import 'package:gpt_flutter/screens/chat_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_flutter/models/summarize_model.dart';
import 'package:gpt_flutter/providers/chats_provider.dart';
import 'package:gpt_flutter/services/firebase_process.dart';
import 'package:gpt_flutter/providers/global_provider.dart';
import 'package:gpt_flutter/services/upload_file_firebase.dart';


class SummarizeDoc extends ConsumerStatefulWidget {
  @override
  _SummarizeDocState createState() => _SummarizeDocState();
}


class _SummarizeDocState extends ConsumerState<SummarizeDoc> {
  bool _fileUploaded = Global.fileUploaded;
  final uploadAndViewFile = UploadAndViewFile();

  @override
  Widget build(BuildContext context) {
    Global.chatType = false;
    return Scaffold(
      appBar:
          MyAppBar(title: "Flutter - Summarize Document", isSidebarOpen: false),
      drawer: MyDrawer(parentContext: context),
      endDrawer: EDrawer(parentContext: context),
      body: Center(
          child: _fileUploaded
              ? ChatScreen(
                  isChatbot: false,
                )
              : _uploadToCon(context) 
          ),
    );
  }

  ElevatedButton _uploadToCon(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {

        showProgressDialog(context, "Uploading...");
        await uploadAndViewFile.selectFile(context);
       
        Navigator.pop(context);
        
        await uploadAndViewFile.readFile(context);
        setState(() {
          _fileUploaded = Global.fileUploaded;
        });

        addToChatList(Global.status, false, DateTime.now().toString());
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0), // Đặt borderRadius
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 5.0, sigmaY: 5.0), // Điều chỉnh độ mờ của viền
              child: Container(
                height: 300,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.black.withOpacity(0.2), // Đặt màu của viền mờ
                ),
                child: Image.asset(
                  'assets/images/3004553.jpg',
                  height: 300,
                  width: 350,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Upload file to continuous',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          Size(350, 400),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.blue;
            }
            return Theme.of(context).colorScheme.secondary;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
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
