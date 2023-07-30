import '../models/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_flutter/models/summarize_model.dart';


class ChatNotifier extends StateNotifier<List<ChatModel>> {
  ChatNotifier() : super([]);
  void add(ChatModel chatModel) {
    state = [...state, chatModel];
  }

  void removeTyping() {
    state = state..removeWhere((chat) => chat.id == 'typing');
  }
}

final chatsProvider = StateNotifierProvider<ChatNotifier, List<ChatModel>>(
  (ref) => ChatNotifier(),
);



class SummarizeNotifier extends StateNotifier<List<SummarizeModel>> {
  SummarizeNotifier() : super([]);

  void add(SummarizeModel summarizeModel) {
    state = [...state, summarizeModel];
  }

  void removeTyping() {
    state = state..removeWhere((chat) => chat.id == 'typing');
  }
}

final summarizeProvider = StateNotifierProvider<SummarizeNotifier, List<SummarizeModel>>(
  (ref) => SummarizeNotifier(),
);