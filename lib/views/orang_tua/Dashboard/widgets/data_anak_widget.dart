import 'package:flutter/material.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_chip_widget.dart';

class DummyChild {
  final String nama;
  final String tanggalLahir;
  final String jenisKelamin;
  final double beratBadan;
  final double tinggiBadan;
  final double lingkarKepala;

  DummyChild({
    required this.nama,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.lingkarKepala,
  });
}

Widget buildDataAnak(BuildContext context) {
  final List<DummyChild> dummyChildren = [
    DummyChild(
      nama: "Aldi",
      tanggalLahir: "12-06-2020",
      jenisKelamin: "Laki-Laki",
      beratBadan: 15.2,
      tinggiBadan: 98.5,
      lingkarKepala: 47.0,
    ),
    DummyChild(
      nama: "Bella",
      tanggalLahir: "25 Agustus 2021",
      jenisKelamin: "Perempuan",
      beratBadan: 12.8,
      tinggiBadan: 90.3,
      lingkarKepala: 45.5,
    ),
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          "Data Anak",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemCount: dummyChildren.length,
          itemBuilder: (context, index) {
            final child = dummyChildren[index];
            final isMale = child.jenisKelamin == "Laki-Laki";
            final genderColor =
                isMale ? Colors.blue.shade600 : Colors.pink.shade600;

            return Container(
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            child.nama,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Icon(Icons.child_care, color: genderColor, size: 28),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lahir: ${child.tanggalLahir}",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),

                        // Gender Chip
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: buildChip(
                              isMale ? "Laki-laki" : "Perempuan",
                              genderColor,
                              icon: isMale ? Icons.male : Icons.female,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
