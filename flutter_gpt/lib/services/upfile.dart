import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() {
  // Get the reference to the file you want to download.
  final ref = FirebaseStorage.instance
      .ref()
      .child('path/to/file.txt');

  // Create a button.
  Widget button = ElevatedButton(
    child: Text('Download File'),
    onPressed: () {
      // Download the file.
      ref.getData().then((data) {
        File file = File('path/to/local/file.txt');
        file.writeAsBytes(data!);
      });
    },
  );

  // Add the button to the screen.
  Scaffold(
    body: Center(
      child: button,
    ),
  );
}