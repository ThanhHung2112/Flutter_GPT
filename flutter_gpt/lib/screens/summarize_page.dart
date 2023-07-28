import 'dart:io';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gpt_flutter/widgets/my_app_bar.dart';
import 'package:gpt_flutter/screens/chat_screen.dart';
import 'package:gpt_flutter/screens/summarize__screen.dart';
import 'package:gpt_flutter/services/upload_file_firebase.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SummarizeDoc extends StatefulWidget {
  @override
  _SummarizeDocState createState() => _SummarizeDocState();
}

class _SummarizeDocState extends State<SummarizeDoc> {
  File? _uploadedFile;
  bool _fileUploaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          MyAppBar(title: "Flutter - Summarize Document", isSidebarOpen: false),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/bot.png', height: 100),
                  Text(
                    'FlutterChatbot',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
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
      body: Center(
        child: _fileUploaded ? SummarizeScreen() : _uploadToCon(context),
      ),
    );
  }

// nonvoi
  void _pickAndUploadFile() async {
    setState(() {
      _fileUploaded = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _uploadedFile = File(result.files.single.path!);
      });
      _uploadFileToFirebaseStorage();
    } else {
      setState(() {
        _fileUploaded = true;
      });
    }
  }

  void _uploadFileToFirebaseStorage() async {
    if (_uploadedFile != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          '.' +
          _uploadedFile!.path.split('.').last;
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('uploads/$fileName')
            .putFile(_uploadedFile!);

        setState(() {
          _fileUploaded = true;
        });
      } catch (e) {
        setState(() {
          _fileUploaded = true;
        });
        print('Lỗi tải tệp lên: $e');
      }
    }
  }

  ElevatedButton _downloadfile(BuildContext context) {
    return ElevatedButton(child: Text("download"), onPressed: () {});
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
        _fileUploaded = true;
      });
    }
  }
}
