import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:gpt_flutter/providers/global_provider.dart';
// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:gpt_flutter/providers/global_provider.dart';

// class AIHandler {
//   final String _apiKey;
//   final String _doc = Global.fileContent;
//   final String _history = Global.chatHistory;
//   final String _sHistory = Global.summaryHistory;

//   AIHandler(this._apiKey) {
//     _openAI = OpenAI.instance.build( 
//       token: Global.openaiKeys,
//          //  "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"
//       baseOption: HttpSetup(
//         receiveTimeout: const Duration(seconds: 100),
//         connectTimeout: const Duration(seconds: 100), //summary the file ?
//       ),
//     );
//   }

//   late final OpenAI _openAI;

//   Future<String> getResponse(String message) async {
//     try {
//         if(Global.chatType){
//         final request = ChatCompleteText(messages: [
//           Map.of({"role": "user", 
//           "content":"""You are chat bot, You having a conversation with human.
//             This is the coversation tha took place between you and human: $_history. 
//             Now answer human questions:$message"""})
//         ], maxToken: 200, model: kChatGptTurbo0301Model);

//         final response = await _openAI.onChatCompletion(request: request);
//         if (response != null) {
//           return response.choices.last.message.content.trim();
//         }
//       } else {
//         final request = ChatCompleteText(messages: [
//           Map.of({
//             "role": "user",
//             "content":
//                 """ You will answer this all the questions about the documentation.
//             Content written in the document: $_doc
//             This is your Coversation: $_sHistory
//             Now answer the human question but do not answer the question which not related to the document
//             Human question: $message"""
//           })
//         ], maxToken: 1000, model: kChatGptTurbo0301Model);

//         final response = await _openAI.onChatCompletion(request: request);
//         if (response != null) {
//           return response.choices[0].message.content.trim();
//         }
//       }

//       return 'Something went wrong';
//     } catch (e) {
//       return 'Bad response';
//     }
//   }
//   void dispose() {
//     _openAI.close();
//   }
// }


class AIHandler {
  final String _apiKey;
  final String _doc = Global.fileContent;
  final String _history = Global.chatHistory;
  final String _sHistory = Global.summaryHistory;
  // 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
  AIHandler(this._apiKey) {
    _openAI = OpenAI.instance.build(
      token: Global.openaiKeys,
      //  "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"
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 100),
        connectTimeout: const Duration(seconds: 100), //summary the file ?
      ),
    );
  }

  late final OpenAI _openAI;

  Future<String> getResponse(String message) async {
    try {
      if (Global.chatType) {
        final request = ChatCompleteText(messages: [
          Map.of({
            "role": "user",
            "content":
                """You are chat bot, You having a conversation with human.
            This is the coversation tha took place between you and human: $_history. 
            Now answer human questions:$message"""
          })
        ], maxToken: 200, model: kChatGptTurbo0301Model);

        final response = await _openAI.onChatCompletion(request: request);
        if (response != null) {
          return response.choices.last.message.content.trim();
        }
      } else {
        

// 5. Thực hiện việc trả lời câu hỏi như ban đầu
        final revisedRequest = ChatCompleteText(
          messages: [
            {
              "role": "user",
              "content":
                  """ You will answer questions about the summarized document.
      Summarized content: $_doc
      Conversation history: $_sHistory
      Now only answer the human question related to the document:
      Human question: $message"""
            }
          ],
          maxToken: 1000,
          model: kChatGptTurbo0301Model, // Chọn mô hình phù hợp
        );

        final response =
            await _openAI.onChatCompletion(request: revisedRequest);
        if (response != null) {
          return response.choices[0].message.content.trim();
        }
      }

      return 'Something went wrong';
    } catch (e) {
      return 'Bad response';
    }
  }

  void dispose() {
    _openAI.close();
  }
}
