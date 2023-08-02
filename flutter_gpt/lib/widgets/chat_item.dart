import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatItem extends StatelessWidget {
  final String text;
  final bool isMe;
  const ChatItem({
    super.key,
    required this.text,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ProfileContainer(isMe: isMe),
          if (!isMe) const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.all(15),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.60,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey.shade800,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: Radius.circular(isMe ? 15 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, 
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
                if (text == "Typing...") 
                  Container()
                else
                  GestureDetector(
                    onTap: () => _speakText(context),
                    child: Icon(
                      Icons.volume_up_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  )
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 15),
          if (isMe) ProfileContainer(isMe: isMe),
        ],
      ),
    );
  }

  Future<void> _speakText(BuildContext context) async {
    final FlutterTts flutterTts = FlutterTts();

    await flutterTts.setLanguage("en-US"); // Set the language (you can change to other languages if needed)
    // await flutterTts.setLanguage("vi-VN");
    await flutterTts.speak(text); // Speak the text in the boxchat
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    super.key,
    required this.isMe,
  });

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isMe
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey.shade800,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
          bottomLeft: Radius.circular(isMe ? 0 : 15),
          bottomRight: Radius.circular(isMe ? 15 : 0),
        ),
      ),
      child: Icon(
        isMe ? Icons.person : Icons.psychology_rounded,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}
