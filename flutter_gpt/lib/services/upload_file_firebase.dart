import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import "package:whisper_dart/whisper_dart.dart";
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gpt_flutter/providers/global_provider.dart';
import 'package:gpt_flutter/services/view_file_firebase.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import "package:whisper_flutter/whisper_flutter.dart";


class UploadAndViewFile {
  Future<void> selectFile(BuildContext context) async {
    final path = await FlutterDocumentPicker.openDocument();
    if (path == null) {
      return; // User didn't select a file
    }
    print(path);
    File file = File(path);
    firebase_storage.UploadTask? task = await uploadFile(file);
    if (task != null) {}
  }

  Future<firebase_storage.UploadTask?> uploadFile(File file) async {
    if (file == null) {
      print("No file was picked");
      Global.status = """No file was picked""";
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Extract the original file name from the path
    String fileName = file.path.split('/').last;

    // Create a Reference to the file with the original file name
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('files')
        .child(fileName);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'file/${getFileExtension(file.path)}',
        customMetadata: {'picked-file-path': file.path});

    print("Uploading..!");

    uploadTask = ref.putData(await file.readAsBytes(), metadata);

    print("done..!");
    Global.status = """File "$fileName" was uploaded successfully""";
    Global.fileUploaded = true;
    Global.currentFileName = fileName;
    return Future.value(uploadTask);
  }

  String getFileExtension(String filePath) {
    final fileExtension = filePath.split('.').last.toLowerCase();
    return fileExtension;
  }

  Future<void> readFile(BuildContext parentContext) async {
    //, File fileD
    showProgressDialog(parentContext, "Processing...");

    // try {
    // Create a reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('files')
        .child(Global.currentFileName);

    Uint8List? fileData = await ref.getData(); //fileD.readAsBytesSync();

    String fileExtension = Global.currentFileName
        .substring(Global.currentFileName.lastIndexOf('.'))
        .toLowerCase();
    var _text;

    if (fileExtension == '.pdf') {
      final pdfDocument = PdfDocument(inputBytes: fileData);
      PdfTextExtractor extractor = PdfTextExtractor(pdfDocument);
      _text = extractor.extractText();
      print("pdf done");
    } else if (fileExtension == '.docx') {
      _text = await docxToText(fileData!);
    } else if (fileExtension == '.mp3' || fileExtension == '.wav') {
      // process audio files
      print("audio processing");

      try {
        final Directory tempDir = Directory.systemTemp;
        final File tempFile = File('${tempDir.path}/audio_file$fileExtension');

        await ref.writeToFile(tempFile);

        // Convert audio to text using whipper
        // String audioText = await convertAudioToText(tempFile);

        // print(audioText);
        // _text = audioText;
      } catch (e) {
        print("Error downloading or converting audio file: $e");
      }
      // _text = await convertAudioToText(fileData!)
      final audio = await _getAudioContent(Global.currentFileName);

      return;
    } else {
      _text = utf8.decode(base64.decode(String.fromCharCodes(fileData!)));
    }
    Navigator.pop(parentContext);
    print(_text.length);
    if (_text.length > 6500) {
      int estimate = _text.length ~/ 5000 * 25 + 25;

      showProgressDialog(parentContext, "Time estimate $estimate s...");

      Global.fileContent = await _mergeDoc(_text);
    } else {
      Global.fileContent = _text;
    }

    Navigator.push(
      parentContext,
      MaterialPageRoute(
        builder: (context) => FileDataScreen(fileData: fileData!),
      ),
    );
    // } catch (e) {
    //   print("Lỗi khi đọc file: $e");
    // }
  }

  Future<void> viewFile(BuildContext parentContext) async {
    showProgressDialog(parentContext, "Processing...");

    // try {
    // Create a reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('files')
        .child(Global.currentFileName);

    Uint8List? fileData = await ref.getData();
    Navigator.push(
      parentContext,
      MaterialPageRoute(
        builder: (context) => FileDataScreen(fileData: fileData!),
      ),
    );
  }
}

void showProgressDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary),
            SizedBox(height: 10),
            Text(message),
          ],
        ),
      );
    },
  );
}

Future<String> _mergeDoc(String doc) async {
  // try {
  final _openAI = OpenAI.instance.build(
    token: Global.openaiKeys,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 1000),
      connectTimeout: const Duration(seconds: 1000),
    ),
  );

  int maxTokensPerSection = 5000;
  int currentTokens = doc.length;
  String fullSummary = "";

  while (currentTokens > maxTokensPerSection) {
    print("start summary");

    int docLength = doc.length;

    print(docLength);
    List<String> documentSections = [];
    for (int i = 0; i < docLength; i += maxTokensPerSection) {
      int endIndex = i + maxTokensPerSection;
      if (endIndex > docLength) {
        endIndex = docLength;
      }
      documentSections.add(doc.substring(i, endIndex));
    }

    List<String> summaries = [];
    for (int sectionIndex = 0;
        sectionIndex < documentSections.length;
        sectionIndex++) {
      final section = documentSections[sectionIndex];
      final summarizeRequest = ChatCompleteText(
        messages: [
          {
            "role": "user",
            "content":
                """Rewrite the following paragraph briefly using the language of the passage while ensuring the main ideas are retained:
                "$section" """
          }
        ],
        maxToken: 200,
        model:
            kChatGptTurbo0301Model, // "gpt-3.5-turbo",// kChatGptTurbo0301Model,//,
      );

      final summarizeResponse =
          await _openAI.onChatCompletion(request: summarizeRequest);
      if (summarizeResponse != null) {
        summaries.add(summarizeResponse.choices.last.message.content.trim());
      }
      print("Process $sectionIndex");

      if (sectionIndex < documentSections.length - 1) {
        await Future.delayed(Duration(seconds: 25));
      }
    }
//NALS, AST ROUGE
    fullSummary = summaries.join("\n");

    final revisedRequest = ChatCompleteText(
      messages: [
        {"role": "user", "content": """Summarized content: $fullSummary"""}
      ],
      maxToken: 1000,
      model: kChatGptTurbo0301Model,
    );

    final response = await _openAI.onChatCompletion(request: revisedRequest);
    if (response != null) {
      return fullSummary;
    } else {
      doc = fullSummary;
    }
  }

  return doc;
  // } catch (e) {
  //   print("fail");
  //   return "failed";
  // }
}
Future<List<int>> _getAudioContent(String name) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path + '/$name';
  return File(path).readAsBytesSync().toList();
}

Future<String> convertAudioToText() async {
  try {
    Whisper whisper = Whisper();
    var res = whisper.request(
      whisperRequest: WhisperRequest.fromWavFile(
        audio: File("assets/service/(31.12.2015). Booking a tour at the travel agent_audio_1.wav"),
        model: File("assets/service/for-tests-ggml-large.bin"),
      ),
    );
    Global.fileContent = res.toString();
    print(res);
    return res.toString();
  } catch (e) {
    print("Lỗi khi chuyển đổi audio thành text: $e");
    return '';
  }
}

// Future<String> convertAudioToText(Uint8List audioData) async {
//   final serviceAccount = ServiceAccount.fromString(
//       '${(await rootBundle.loadString('assets/service/sync-request.json'))}');
//   final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
//   final config = RecognitionConfig(
//     encoding: AudioEncoding.LINEAR16,
//     model: RecognitionModel.basic,
//     enableAutomaticPunctuation: true,
//     sampleRateHertz: 16000,
//     languageCode: 'en-US',
//   );

//   final transcript = await speechToText.recognize(config, audioData);
//   String text = transcript.results
//       .map((e) => e.alternatives.first.transcript)
//       .join('\n');
//   return text;
// }
  // Future<String> _convertAudioToText(File audioFile) async {
  //   try {
  //     // File model = ;
  //     Whisper whisper = Whisper();
  //     var res = await whisper.request(
  //       whisperLib:
  //           "libwhisper.so",
  //       whisperRequest: WhisperRequest.fromWavFile(
  //         audio: audioFile,
  //         model: File("assets/service/for-tests-ggml-large.bin"),
  //       ),
  //     );
  //     // Whisper whisper = Whisper();
  //     // Transcribe transcribe = await whisper.transcribe(
  //     //   audio: audioFile,
  //     //   model: "assets/service/for-tests-ggml-large.bin",
  //     //   language: "id", // language
  //     // );
  //     // print(transcribe);
  //     return res.toString();
  //   } catch (e) {
  //     print("Error converting audio to text: $e");
  //     return "";
  //   }
  // }
