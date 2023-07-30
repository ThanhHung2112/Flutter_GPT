import 'dart:io';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gpt_flutter/widgets/my_app_bar.dart';
import 'package:gpt_flutter/screens/chat_screen.dart';
import 'package:gpt_flutter/providers/global_provider.dart';
import 'package:gpt_flutter/services/upload_file_firebase.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SummarizeDoc extends StatefulWidget {
  @override
  _SummarizeDocState createState() => _SummarizeDocState();
}

class _SummarizeDocState extends State<SummarizeDoc> {
  bool _fileUploaded = Global.fileUploaded;

  @override
  Widget build(BuildContext context) {
     Global.chatType = false;
    return Scaffold(
      appBar:
          MyAppBar(title: "Flutter - Summarize Document", isSidebarOpen: false),
      drawer: MyDrawer(),
      body: Center(
          child: _fileUploaded
              ? ChatScreen(isChatbot: false,)
              : _uploadToCon(context) // PDFWorking(),//,
          ),
    );
  }

  ElevatedButton _uploadToCon(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectFile(context),
      // {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPDF()));
      // },//_pickAndUploadFile,
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

  Future<void> _selectFile(BuildContext context) async {
    final path = await FlutterDocumentPicker.openDocument();
    print(path);
    File file = File(path!);
    firebase_storage.UploadTask? task = await uploadFile(file);
    if (task != null) {
      setState(() {
        _fileUploaded = Global.fileUploaded;
      });
    }
  }
}
