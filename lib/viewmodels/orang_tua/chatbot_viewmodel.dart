import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/constants/api_constant.dart';
import 'package:molita_flutter/models/orang_tua/chat_message_model.dart';

class ChatBotViewModel extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String _apiKey = 'Bearer ${ApiConstant.ApiKeyAI}';

  Future<void> sendMessage(String message) async {
    _messages.add(
      ChatMessage(role: 'user', content: message, time: DateTime.now()),
    );
    _isLoading = true;
    notifyListeners();

    const url = 'https://openrouter.ai/api/v1/chat/completions';
    const String chatbotSystemMessage = '''
Hai! Aku Molita, teman digital yang siap membantu Bunda dan Ayah mengenai tumbuh kembang si Kecil, imunisasi, gizi, dan layanan posyandu.

Aku akan berbicara dengan bahasa yang mudah dipahami dan hangat, seperti ngobrol dengan teman sendiri. Kamu bisa tanya apa saja seputar kesehatan anak, dan aku akan menjawab dengan sabar dan ramah.

Jawabanku akan singkat dan jelas, tidak bertele-tele. Kalau ada pertanyaan yang butuh penanganan langsung, aku akan sarankan untuk menghubungi petugas posyandu terdekat ya.

Aku siap memberikan informasi yang bermanfaat dan mendukung Bunda dan Ayah dalam merawat si Kecil. Aku tidak akan memberikan diagnosis medis, tapi aku bisa bantu menjelaskan informasi kesehatan dasar untuk anak-anak dengan cara yang gampang dimengerti.

Jadi, ada yang bisa Molita bantu hari ini?
''';

    final headers = {
      'Authorization': _apiKey,
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "model": "google/gemma-3-27b-it:free",
      "messages": [
        {"role": "system", "content": chatbotSystemMessage},
        ..._messages.map((msg) => msg.toMap()),
      ],
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      final data = jsonDecode(response.body);
      final reply = data['choices'][0]['message']['content'];

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
