import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/edukasi_viewmodel.dart';

Widget buildCategoryFilter(Color primaryColor, EdukasiViewModel viewModel) {
    return Row(
      children: [
        Icon(Icons.category_rounded, color: primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          'Kategori:',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                value: viewModel.selectedCategory,
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: primaryColor,
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) viewModel.setSelectedCategory(newValue);
                },
                items: [
                  DropdownMenuItem(
                    value: 'Semua',
                    child: Text(
                      'Semua Kategori',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  ...viewModel.categories.map(
                    (category) => DropdownMenuItem(
                      value: category.judul,
                      child: Text(category.judul),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }