import 'package:flutter/material.dart';
import 'package:molita_flutter/views/common/Login/login_view.dart';
import 'package:molita_flutter/views/common/Register/register_view.dart';
import 'package:molita_flutter/views/orang_tua/Menu/menu_view.dart';
import 'package:molita_flutter/views/orang_tua/Onboarding/onboarding_view.dart';
import 'package:molita_flutter/views/orang_tua/Onboarding/splash_screen_view.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashScreenView(),
    '/onboarding': (context) => OnboardingView(),
    '/login': (context) => LoginView(),
    '/register': (context) => RegisterView(),
    '/home': (context) => MenuView(),
  };
}
