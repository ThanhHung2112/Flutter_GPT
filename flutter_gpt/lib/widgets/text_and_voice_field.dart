import 'toggle_button.dart';
import '../models/chat_model.dart';
import '../services/ai_handler.dart';
import 'package:flutter/material.dart';
import '../services/voice_handler.dart';
import '../providers/chats_provider.dart';
import '../services/firebase_process.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_flutter/models/summarize_model.dart';
import 'package:gpt_flutter/providers/global_provider.dart';

enum InputMode {
  text,
  voice,
}

class TextAndVoiceField extends ConsumerStatefulWidget {
  const TextAndVoiceField({super.key});
  @override
  ConsumerState<TextAndVoiceField> createState() => _TextAndVoiceFieldState();
}

class _TextAndVoiceFieldState extends ConsumerState<TextAndVoiceField> {
  InputMode _inputMode = InputMode.voice;
  final _messageController = TextEditingController();
  final VoiceHandler voiceHandler = VoiceHandler();
  var _isReplying = false;
  var _isListening = false;
  String openaiKey = Global.openaiKeys;
  // final bool isChatbot = ;
  @override
  void initState() {
    voiceHandler.initSpeech();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    // _openAI.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            onChanged: (value) {
              value.isNotEmpty
                  ? setInputMode(InputMode.text)
                  : setInputMode(InputMode.voice);
            },
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 06,
        ),
        ToggleButton(
          isListening: _isListening,
          isReplying: _isReplying,
          inputMode: _inputMode,
          sendTextMessage: () {
            final message = _messageController.text;
            _messageController.clear();
            sendTextMessage(message);
          },
          sendVoiceMessage: sendVoiceMessage,
        )
      ],
    );
  }

  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  void sendVoiceMessage() async {
    if (!voiceHandler.isEnabled) {
      print('Not supported');
      return;
    }
    if (voiceHandler.speechToText.isListening) {
      await voiceHandler.stopListening();
      setListeningState(false);
    } else {
      setListeningState(true);
      final result = await voiceHandler.startListening();
      setListeningState(false);
      sendTextMessage(result);
    }
  }

  void sendTextMessage(String message) async {
    if (Global.isFirstMessage) {
      String ID =
          await AIHandler(Global.openaiKeys).getConversationName(message);
      Global.chatType ? Global.chatID = ID : Global.summarizeID = ID;
      Global.isFirstMessage = false;
      if (!Global.chatType) {
        firebaseProcess().sendMessageToFirebase(
            Global.status, false, DateTime.now().toString());
      }
    }
    setReplyingState(true);
    String id = DateTime.now().toString();
    addToChatList(message, true, id);

    addToChatList('Typing...', false, 'typing');
    setInputMode(InputMode.voice);

    final aiResponse = await AIHandler(Global.openaiKeys).getResponse(message);

    if (Global.chatType) {
      Global.chatHistory = Global.chatHistory + "user: " + message + "\n";
      Global.chatHistory = Global.chatHistory + "you: " + aiResponse + "\n";
      // addToChatList(Global.chatHistory, true, id);
    } else {
      Global.summaryHistory = Global.summaryHistory + "user: " + message + "\n";
      Global.summaryHistory =
          Global.summaryHistory + "you: " + aiResponse + "\n";
      // addToChatList(Global.summaryHistory, true, id);
    }
    removeTyping();
    String idb = DateTime.now().toString();
    addToChatList(aiResponse, false, idb);
    setReplyingState(false);
  }

  void setReplyingState(bool isReplying) {
    setState(() {
      _isReplying = isReplying;
    });
  }

  void setListeningState(bool isListening) {
    setState(() {
      _isListening = isListening;
    });
  }

  void removeTyping() {
    if (Global.chatType) {
      final chats = ref.read(chatsProvider.notifier);
      chats.removeTyping();
    } else {
      final chats = ref.read(summarizeProvider.notifier);
      chats.removeTyping();
    }
  }

  void addToChatList(String message, bool isMe, String id) {
    if (Global.chatType) {
      final chats = ref.read(chatsProvider.notifier);
      chats.add(ChatModel(
        id: id,
        message: message,
        isMe: isMe,
      ));
    } else {
      final chats = ref.read(summarizeProvider.notifier);
      chats.add(SummarizeModel(
        id: id,
        message: message,
        isMe: isMe,
      ));
    }
    if (message != "Typing...") {
      firebaseProcess().sendMessageToFirebase(message, isMe, id);
    }
  }
}
