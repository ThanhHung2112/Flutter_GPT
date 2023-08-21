import 'package:flutter/material.dart';
import '../providers/chats_provider.dart';
import 'package:gpt_flutter/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpt_flutter/models/summarize_model.dart';
import 'package:gpt_flutter/providers/global_provider.dart';

class firebaseProcess {
  void sendMessageToFirebase(String message, bool isMe, String id) async {
    String path = (Global.chatType
            ? "/chats/" + Global.chatID
            : "/summaries/" + Global.summarizeID) +
        "/chat";
    final CollectionReference chatCollection = FirebaseFirestore.instance
        .collection(Global.chatType ? "/chats/" : "/summaries/");
    chatCollection
        .doc(Global.chatType ? Global.chatID : Global.summarizeID)
        .set({'isMe': isMe}).then((value) {
      final CollectionReference chatCollection =
          FirebaseFirestore.instance.collection(path);
      chatCollection.doc(id).set(Global.chatType
          ? {'message': message, 'isMe': isMe, 'id': id}
          : {
              'message': message,
              'isMe': isMe,
              'id': id,
              "filename": Global.currentFileName
            });
      print("Message sent to Firebase");
    }).catchError((error) {
      print("Error sending message: $error");
    });
  }

  Future deleteChatHistory(String ID) async {
    String collectionPath = (Global.chatType ? "/chats/" : "/summaries/") + ID;

    final DocumentReference docReference =
        FirebaseFirestore.instance.doc(collectionPath);

    try {
      await docReference.delete();
      CollectionReference chatCollection =
          FirebaseFirestore.instance.collection(collectionPath + "/chat/");
      var snapshots = await chatCollection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      print("Chat history deleted");
      return true;
    } catch (e) {
      print("Error deleting chat history");
      return false;
    }
  }
}
