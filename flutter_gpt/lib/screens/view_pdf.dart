import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gpt_flutter/providers/global_provider.dart';
// import 'package:flutter_file_view/flutter_file_view.dart';


class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl;

  PDFViewerScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: Center(
        child:  
        //  FileView(
        //   bytes: fileData,
        //   fileType: FileType.pdf, // Specify the file type as PDF
        // ),
        PDFView(
          filePath: pdfUrl,
          onPageChanged: (int? page, int? total) {
            print('Page changed: $page / $total');
          },
        ),

      ),
      
    );
  }
  
}