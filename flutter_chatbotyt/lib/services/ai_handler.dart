import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'dart:async';

class AIHandler {
  final _openAI = OpenAI.instance.build(
      token: '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',
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
      enableLog: true);
 
  CancelData? mCancel;

  // mCancel?.cancelToken.cancel("canceled ");
  void dispose(CancelData cancelData) {
    mCancel = cancelData;
    // _openAI.close();
  }

  Future<String> getResponse(String message) async {
    try {
      final request = ChatCompleteText(
        messages: [
          Messages(
              role: Role.user,
              content: message,
              ),
        ],
        maxToken: 200,
        model: GptTurboChatModel(),
      ); // TranslatemodelV3

      final response = await _openAI.onChatCompletion(request: request);
      if (response != null) {
        return response.choices[0].message!.content.trim();
      }

      return 'Something went wrong ...';
    } catch (e) {
      return 'Bad response: ';
    }
  }

  ///CancelData
  
}
