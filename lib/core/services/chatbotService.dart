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

  Future<String> getGrafikDeskripsi({
    required String jenisGrafik,
    required String statusBBU,
    required String zscoreBBU,
    required String statusTBU,
    required String zscoreTBU,
    required String statusBBTB,
    required String zscoreBBTB,
  }) async {
    final headers = {
      'Authorization': _apiKey,
      'Content-Type': 'application/json',
    };

    String prompt = '';
    switch (jenisGrafik) {
      case 'Berat Badan':
        prompt = '''
Hai Molita, bantu buatkan deskripsi singkat dan ramah tentang grafik **Berat Badan menurut Umur (BB/U)** anak berikut ini (maksimal 100 kata):
- Status Gizi: $statusBBU
- Z-score: $zscoreBBU

Gunakan gaya bahasa yang mudah dipahami orang tua dan beri saran sederhana jika perlu.
''';
        break;
      case 'Tinggi Badan':
        prompt = '''
Hai Molita, bantu buatkan deskripsi singkat dan ramah tentang grafik **Tinggi Badan menurut Umur (TB/U)** anak berikut ini (maksimal 100 kata):
- Status Gizi: $statusTBU
- Z-score: $zscoreTBU

Gunakan gaya bahasa yang mudah dipahami orang tua dan beri saran sederhana jika perlu.
''';
        break;
      case 'Semua':
      default:
        prompt = '''
Hai Molita, bantu buatkan deskripsi singkat dan ramah tentang grafik pertumbuhan anak secara keseluruhan berikut ini (maksimal 100 kata):
- BB/U: $statusBBU (Z-score: $zscoreBBU)
- TB/U: $statusTBU (Z-score: $zscoreTBU)
- BB/TB: $statusBBTB (Z-score: $zscoreBBTB)

Gunakan gaya bahasa yang mudah dipahami orang tua dan beri saran sederhana jika perlu.
''';
        break;
    }

    final body = jsonEncode({
      "model": "mistralai/mistral-7b-instruct:free",
      "messages": [
        {"role": "system", "content": _systemMessage},
        {"role": "user", "content": prompt},
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
        'Gagal mendapatkan deskripsi grafik (${response.statusCode})',
      );
    }
  }
}
