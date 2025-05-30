import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/chat_message_model.dart';

class ChatBotService {
  static const _url = 'https://openrouter.ai/api/v1/chat/completions';
  static const _systemMessage = '''
Hai! Aku Molita, teman digital yang siap membantu Bunda dan Ayah mengenai tumbuh kembang si Kecil, imunisasi, gizi, dan layanan posyandu.

Aku akan berbicara dengan bahasa yang mudah dipahami dan hangat, seperti ngobrol dengan teman sendiri. Kamu bisa tanya apa saja seputar kesehatan anak, dan aku akan menjawab dengan sabar dan ramah.

Jawabanku akan singkat dan jelas, tidak bertele-tele. Kalau ada pertanyaan yang butuh penanganan langsung, aku akan sarankan untuk menghubungi petugas posyandu terdekat ya.

Aku siap memberikan informasi yang bermanfaat dan mendukung Bunda dan Ayah dalam merawat si Kecil. Aku tidak akan memberikan diagnosis medis, tapi aku bisa bantu menjelaskan informasi kesehatan dasar untuk anak-anak dengan cara yang gampang dimengerti.

Jadi, ada yang bisa Molita bantu hari ini?
''';

  final String _apiKey = 'Bearer ${AppConstant.ApiKeyAI}';

  Future<String> getChatBotReply(List<ChatMessage> messages) async {
    final headers = {
      'Authorization': _apiKey,
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "model": "google/gemma-3-27b-it:free",
      "messages": [
        {"role": "system", "content": _systemMessage},
        ...messages.map((msg) => msg.toMap()),
      ],
    });

    final response = await http.post(
      Uri.parse(_url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception(
        'Gagal mendapatkan balasan dari Molita (${response.statusCode})',
      );
    }
  }
}
