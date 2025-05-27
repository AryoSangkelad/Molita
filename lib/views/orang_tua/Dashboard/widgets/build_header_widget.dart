import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';

Widget buildHeader(BuildContext context, OrangTua orangTua) {
  final screenHeight = MediaQuery.of(context).size.height;
  final headerHeight = screenHeight * 0.20; // 25% dari tinggi layar
  final circleSize = headerHeight * 0.9; // ukuran lingkaran proporsional

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
            bottom: headerHeight * 0.47,
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
                    "Hai, ${orangTua.namaIbu}",
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
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(
                    "${AppConstant.baseUrl}storage/${orangTua.img}",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
