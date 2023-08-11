import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gpt_flutter/screens/summarize_page.dart';
import 'package:gpt_flutter/providers/global_provider.dart';

class FileDataScreen extends StatelessWidget {
  final Uint8List fileData; // Biến dữ liệu của file

  FileDataScreen({required this.fileData});

  @override
  Widget build(BuildContext context) {
    String fileExtension = Global.currentFileName
        .substring(Global.currentFileName.lastIndexOf('.'))
        .toLowerCase();
    return Scaffold(
      appBar: AppBar(
        title: Text('File Data'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), // Icon mũi tên quay lại
          onPressed: () {
            // Khi nhấn nút mũi tên quay lại, chuyển đến màn hình Summarize()
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SummarizeDoc()), 
            );
          },
        ),
      ),
      body: fileExtension == ".pdf"
          ? Center(
              child: PDFView(
                pdfData: fileData,
              ),
            )
          : Center(
              child: Text(
                Global.fileContent,
                style: TextStyle(fontSize: 18),
              ),
            ),
    );
  }
}
