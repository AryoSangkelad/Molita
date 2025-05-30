import 'package:flutter/material.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/pertumbuhan_viewmodel.dart';

Widget buildAnakDropdown(PertumbuhanViewModel model, Color weightColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            'PILIH ANAK',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: weightColor,
              fontSize: 12,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<Anak>(
            value: model.selectedAnak,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: weightColor),
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            dropdownColor: Colors.white,
            onChanged: (Anak? newValue) {
              if (newValue != null) {
                model.setSelectedAnak(newValue);
              }
            },
            items:
                model.daftarAnak.map((anak) {
                  return DropdownMenuItem<Anak>(
                    value: anak,
                    child: Text(
                      anak.nama,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }