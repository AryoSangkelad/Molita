import 'package:flutter/material.dart';
import 'package:molita_flutter/models/common/onboarding_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void nextPage(PageController controller) {
    if (_currentIndex < onboardingList.length - 1) {
      controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void updatePage(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  List<OnboardingModel> get onboardingList => [
    OnboardingModel(
      title: 'Selamat datang di Molita',
      description: 'Jangan lupa pantau kesehatan buah hati anda',
      imageAsset: 'molita.png',
      animation: false,
    ),
    OnboardingModel(
      title: 'Kontrol Pertumbuhan Balita',
      description: 'Pantau pertumbuhan balita mu dari genggaman',
      imageAsset: 'slide3.json',
      animation: true,
    ),
    OnboardingModel(
      title: 'Desain Aplikasi yang Modern',
      description: 'Aplikasi yang mudah dimengerti dan digunakan',
      imageAsset: 'anim_application.json',
      animation: true,
    ),
  ];
}
