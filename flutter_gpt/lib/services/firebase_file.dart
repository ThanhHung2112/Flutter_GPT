import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadPDF extends StatelessWidget {
  
  Future<firebase_storage.UploadTask?> uploadFile(File file) async {
    if (file == null) {
      print("No file was picked");
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('files')
        .child('/some-file.pdf');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'file/pdf',
        customMetadata: {'picked-file-path': file.path});
    print("Uploading..!");

    uploadTask = ref.putData(await file.readAsBytes(), metadata);

    print("done..!");
    return Future.value(uploadTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Select File'),
          onPressed: () => _selectFile(context),
        ),
      ),
    );
  }

  Future<void> _selectFile(BuildContext context) async {
    final path = await FlutterDocumentPicker.openDocument();
    print(path);
    File file = File(path!);
    firebase_storage.UploadTask? task = await uploadFile(file);
    Navigator.pop(context);
  }

  
}
