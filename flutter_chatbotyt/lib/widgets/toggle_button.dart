import 'package:flutter/material.dart';
import 'package:flutter_chatbotyt/widgets/text_and_voice_field.dart';

class ToggleButton extends StatefulWidget {
  final VoidCallback _sendTextMessage;
  final VoidCallback _sendVoiceMessage;

  final InputMode _inputMode;
  const ToggleButton({
    super.key,
    required InputMode inputMode,
    required VoidCallback sendTextMessage,
    required VoidCallback sendVoiceMessage,
  })  : _inputMode = inputMode,
        _sendTextMessage = sendTextMessage,
        _sendVoiceMessage = sendVoiceMessage;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          shape: const CircleBorder(),
          padding: EdgeInsets.all(15)),
      onPressed: widget._inputMode == InputMode.text
          ? widget._sendTextMessage
          : widget._sendTextMessage,
      child: Icon(widget._inputMode == InputMode.text ? Icons.send : Icons.mic),
    );
  }
}
