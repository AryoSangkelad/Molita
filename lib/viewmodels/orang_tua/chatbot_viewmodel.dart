import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/chatbotService.dart';
import 'package:molita_flutter/models/orang_tua/chat_message_model.dart';

class ChatBotViewModel extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ChatBotService _chatBotService = ChatBotService();

  List<ChatMessage> get messages => _messages;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String message) async {
    _messages.add(
      ChatMessage(role: 'user', content: message, time: DateTime.now()),
    );
    _isLoading = true;
    notifyListeners();

    try {
      final reply = await _chatBotService.getChatBotReply(_messages);
      _messages.add(
        ChatMessage(role: 'assistant', content: reply, time: DateTime.now()),
      );
    } catch (e) {
      _messages.add(
        ChatMessage(
          role: 'assistant',
          content: '❌ Error: ${e.toString()}',
          time: DateTime.now(),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
