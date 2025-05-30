import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/pertumbuhan_viewmodel.dart';

Widget buildGrafikTabs(PertumbuhanViewModel model, Color weightColor) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color.fromARGB(255, 215, 223, 255), // Warna outline
          width: 1.5, // Ketebalan outline
        ),
      ),
      child: Row(
        children:
            ['Semua', 'Berat Badan', 'Tinggi Badan'].map((jenis) {
              final bool isSelected = jenis == model.selectedGrafik;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => model.setSelectedGrafik(jenis),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? weightColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: weightColor.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : [],
                      ),
                      child: Center(
                        child: Text(
                          jenis,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }