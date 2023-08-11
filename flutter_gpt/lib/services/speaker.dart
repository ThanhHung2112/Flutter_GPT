import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


Future<void> _speakText(BuildContext context) async {
    final FlutterTts flutterTts = FlutterTts();

    await flutterTts.setLanguage("en-US"); // Set the language (you can change to other languages if needed)

    await flutterTts.speak("text"); // Speak the text in the boxchat
  }