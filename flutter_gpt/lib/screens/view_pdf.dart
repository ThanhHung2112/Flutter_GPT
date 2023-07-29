import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';


class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl;

  PDFViewerScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: Center(
        child: PDFView(
          filePath: pdfUrl,
          onPageChanged: (int? page, int? total) {
            print('Page changed: $page / $total');
          },
        ),
      ),
    );
  }
  
}