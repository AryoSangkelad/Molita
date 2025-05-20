import 'package:flutter/material.dart';

Widget buildHeader(BuildContext context, String username) {
  final screenHeight = MediaQuery.of(context).size.height;
  final headerHeight = screenHeight * 0.25; // 25% dari tinggi layar
  final circleSize = headerHeight * 0.8; // ukuran lingkaran proporsional

  return Container(
    height: headerHeight,
    width: double.infinity,
    decoration: const BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
    ),
    child: Stack(
      children: [
        // Background hiasan lingkaran transparan
        Positioned(
          top: -circleSize * 0.5,
          left: -circleSize * 0.5,
          child: Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: headerHeight * 0.55,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Teks sambutan
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Hai, $username",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Yuk pastikan kesehatan anak terjamin!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),

              // Avatar pengguna
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(
                    'assets/images/avatar.png',
                  ), // ganti jika belum ada
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
