import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class AIHandler {
  final String keys = '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';

  void dispose() {
    _openAI.close();
  }
  
  final _openAI = OpenAI.instance.build(
    token: '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',
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 20),
    ),
  );

  Future<String> getResponse(String message) async {
    try {
      final request = ChatCompleteText(messages: [
        Map.of({"role": "user", "content": message})
      ], maxToken: 200, model: kChatGptTurbo0301Model);

      final response = await _openAI.onChatCompletion(request: request);
      if (response != null) {
        return response.choices[0].message.content.trim();
      }

      return 'Some thing went wrong'; 
    } catch (e) {
      return 'Bad response';
    }
  }

}
