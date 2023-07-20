import '../models/chat_mode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatNotifier extends StateNotifier<List<ChatModel>> {
  ChatNotifier() : super([]);
  void add(ChatModel chatModel) {
    state = [...state, chatModel];
  }
}

final chatsProvider = StateNotifierProvider<ChatNotifier, List<ChatModel>>(
  (ref) => ChatNotifier(),
);
