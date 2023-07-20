import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chatbotyt/models/chat_mode.dart';
import 'package:flutter_chatbotyt/services/ai_handler.dart';
import 'package:flutter_chatbotyt/widgets/toggle_button.dart';
import 'package:flutter_chatbotyt/providers/chats_provider.dart';

enum InputMode { text, voice }

class TextAndVoiceField extends ConsumerStatefulWidget {
  const TextAndVoiceField({super.key});

  @override
  ConsumerState<TextAndVoiceField> createState() => _TextAndVoiceFieldState();
}

class _TextAndVoiceFieldState extends ConsumerState<TextAndVoiceField> {
  InputMode _inputMode = InputMode.voice;
  final _messageController = TextEditingController();
  AIHandler _openAI = AIHandler();
  
  @override
  void dispose() {
    // TODO: implement dispose
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary),
                    borderRadius: BorderRadius.circular(12))),
          ),
        ),
        const SizedBox(
          width: 6,
        ),  
        ToggleButton(
          inputMode: _inputMode,
          sendTextMessage: () {
            sendTextMessage(_messageController.text);
          },
          sendVoiceMessage: sendVoiceMessage,
        ),
      ],
    );
  }

  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  void sendVoiceMessage() {}
  void sendTextMessage(String message) async {
    addToChatList(message, true, DateTime.now().toString());
    final aiResponse = await _openAI.getResponse(message);
    addToChatList(
      aiResponse,
      false,
      DateTime.now().toString(),
    );
  }

  void addToChatList(String message, bool isMe, String id,) {
    final chats = ref.read(chatsProvider.notifier);
    chats.add(ChatModel(
      id: id,
      message: message,
      isMe: isMe,
    ));
  }
}
