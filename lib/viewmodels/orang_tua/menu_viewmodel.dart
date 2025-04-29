import 'package:flutter/material.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/dashboard_view.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/edukasi_view.dart';
import 'package:molita_flutter/views/orang_tua/Grafik/grafik_view.dart';
import 'package:molita_flutter/views/orang_tua/Penjadwalan/penjadwalan_view.dart';
import 'package:molita_flutter/views/orang_tua/Profile/profile_view.dart';

class MenuViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    DashboardView(),
    PenjadwalanView(),
    EdukasiView(),
    GrafikView(),
    ProfileView(),
  ];

  int get currentIndex => _currentIndex;
  List<Widget> get pages => _pages;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
