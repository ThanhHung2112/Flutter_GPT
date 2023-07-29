import 'dart:io';
import 'theme_switch.dart';
import 'package:flutter/material.dart';
import '../providers/active_theme_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gpt_flutter/screens/view_pdf.dart';
import 'package:gpt_flutter/screens/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_flutter/services/upload_file_firebase.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;



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
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
          : IconButton(
              icon: Icon(Icons.menu),
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
        child: Image.asset('assets/images/flutter_aibot.png', height: 120),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final String pdfFileName = 'some-file.pdf';

  Future<String> _downloadPDF() async {
    try {
      final pdfRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('files');
      final bytes = await pdfRef.getData();
      final dir = await getTemporaryDirectory();
      final file = File('files/some-file.pdf');
      await file.writeAsBytes(bytes!);
      print('PDF downloaded successfully: ${file.path}');
      return file.path;
    } catch (e) {
      print('Error downloading PDF: $e');
      return '';
    }
  }

  void _navigateToPDFViewer(BuildContext context) async {
    print('Navigating to PDF viewer...');
    String pdfUrl = await _downloadPDF();
    if (pdfUrl.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(pdfUrl: pdfUrl),
        ),
      );
    }
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
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage()), // Replace HomePage with your desired page
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.drive_folder_upload),
                  title: Text('Upload PDF'),
                  onTap: () => _selectFile(context),
                ),
                ListTile(
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text('View PDF'),
                  onTap: () => _navigateToPDFViewer(context),
                ),
                ListTile(
                  leading: Icon(Icons.arrow_back),
                  title: Text('Return'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    // TODO: Handle when the user taps on the return button in the drawer
                  },
                ),
                // Add other items of the sidebar as needed
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Close'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
  Future<void> _selectFile(BuildContext context) async {
    final path = await FlutterDocumentPicker.openDocument();
    print(path);
    File file = File(path!);
    firebase_storage.UploadTask? task = await uploadFile(file);
  }
}