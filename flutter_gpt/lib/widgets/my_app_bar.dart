import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../providers/active_theme_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gpt_flutter/screens/view_pdf.dart';
import 'package:gpt_flutter/screens/home_page.dart';
import 'package:gpt_flutter/screens/chat_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_flutter/screens/summarize_page.dart';
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

class MyDrawer extends StatelessWidget {
  final BuildContext parentContext; // Accept the BuildContext as a parameter
  final String pdfFileName = 'some-file.pdf';
  Uint8List? fileData;
  MyDrawer({required this.parentContext});
  // Future<String> _downloadPDF() async {
  //   try {
  //     final pdfRef =
  //         firebase_storage.FirebaseStorage.instance.ref().child('files');
  //     final bytes = await pdfRef.getData();
  //     final dir = await getTemporaryDirectory();
  //     final file = File('files/some-file.pdf');
  //     await file.writeAsBytes(bytes!);
  //     print('PDF downloaded successfully: ${file.path}');
  //     return file.path;
  //   } catch (e) {
  //     print('Error downloading PDF: $e');
  //     return '';
  //   }
  // }

  void _navigateToPDFViewer(BuildContext context) async {
    print('Navigating to PDF viewer...');
    // String pdfUrl = await _downloadPDF();
    // if (pdfUrl.isNotEmpty) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => PDFViewerScreen(pdfUrl: pdfUrl),
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
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
                          'assets/images/bot.png',
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
                    'Upload PDF',
                    style: TextStyle(fontSize: 17),
                  ),
                  onTap: () => _selectFile(),
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/view-file.svg', // Đường dẫn đến tệp SVG cho hình ảnh
                    height: 25,
                    width: 25,
                  ),
                  title: Text(
                    'View PDF',
                    style: TextStyle(fontSize: 17),
                  ),
                  onTap: () => _readFile(), //_navigateToPDFViewer(context),
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/back.svg', // Đường dẫn đến tệp SVG cho hình ảnh
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

  Future<void> _selectFile() async {
    final path = await FlutterDocumentPicker.openDocument();
    print(path);
    File file = File(path!);
    firebase_storage.UploadTask? task = await uploadFile(file);
  }

  Future<void> _readFile() async {
    try {
      // Create a reference to the file
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('files')
          .child(Global.currentFileName);

      // Tải dữ liệu của file
      fileData = await ref.getData();
      final pdfDocument = PdfDocument(inputBytes: fileData!);
      
      PdfTextExtractor extractor = PdfTextExtractor(pdfDocument);
      String text = extractor.extractText();

      Global.fileContent = text;

      Navigator.push(
        parentContext, // Use parentContext here instead of context
        MaterialPageRoute(
          builder: (context) => FileDataScreen(fileData: fileData!),
        ),
      );
    } catch (e) {
      print("Lỗi khi đọc file: $e");
    }
  }
}
