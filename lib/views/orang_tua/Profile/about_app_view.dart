import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppView extends StatelessWidget {
  const AboutAppView({super.key});

  void _launchWebsite() async {
    final Uri url = Uri.parse('https://molita.org');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaduan"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Colors.grey[900]!, Colors.black]
                : [const Color(0xFFE3F2FD), Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tentang Molita',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Molita',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text:
                    ' adalah aplikasi pemantauan anak yang dirancang untuk membantu orang tua dan posyandu memantau perkembangan anak dengan mudah dan terorganisir.\n\n',
                  ),
                ],
              ),
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            Text(
              'Melalui Molita, pengguna dapat:',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '1. Melacak jadwal imunisasi\n'
                  '2. Mencatat perkembangan berat dan tinggi badan\n'
                  '3. Mengakses informasi kesehatan anak yang penting\n',
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              'Aplikasi ini bertujuan untuk mendukung tumbuh kembang anak secara optimal dengan menyediakan data yang akurat dan fitur yang praktis. Molita hadir untuk memberikan kenyamanan bagi orang tua dalam menjaga kesehatan dan tumbuh kembang buah hati.\n',
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            GestureDetector(
              onTap: _launchWebsite,
              child: Text(
                'Kunjungi website resmi kami di: https://molita.org',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
