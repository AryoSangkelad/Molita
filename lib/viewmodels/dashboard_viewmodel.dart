import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';

class DashboardViewModel extends ChangeNotifier {
  String username = "Adel";

  List<ChildData> children = [
    ChildData(
      name: "Aulia Rahma",
      birthDate: "Senin, 2 Maret 2023",
      immunization: "POLIO",
      weight: 4.0,
      height: 60.0,
      headCircumference: 45.0,
    ),
  ];

  List<EducationItem> educationItems = [
    EducationItem(title: "Peran Posyandu", description: "Peran Posyandu dalam Tumbuh Kembang Anak dan Balita."),
    EducationItem(title: "Makanan Sehat", description: "Makanan yang Tepat untuk Tumbuh Kembang Optimal."),
    EducationItem(title: "Cegah Stunting", description: "Cegah Stunting Mulai dari Posyandu."),
  ];
}
