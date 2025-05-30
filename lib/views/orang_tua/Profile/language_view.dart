import 'package:flutter/material.dart';

class BahasaView extends StatelessWidget {
  const BahasaView({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedLanguage = 'id';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bahasa"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile(
              title: const Text("Bahasa Indonesia"),
              value: 'id',
              groupValue: selectedLanguage,
              onChanged: (value) {
                // Ganti bahasa aplikasi ke Indonesia
              },
            ),
            RadioListTile(
              title: const Text("English"),
              value: 'en',
              groupValue: selectedLanguage,
              onChanged: (value) {
                // Ganti bahasa aplikasi ke Inggris
              },
            ),
          ],
        ),
      ),
    );
  }
}
