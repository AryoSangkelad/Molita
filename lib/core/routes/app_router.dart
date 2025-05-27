import 'package:flutter/material.dart';
import 'package:molita_flutter/views/common/Login/login_view.dart';
import 'package:molita_flutter/views/common/Register/register_view.dart';
import 'package:molita_flutter/views/common/lupa_password/lupa_password.dart';
import 'package:molita_flutter/views/common/lupa_password/verifikasi_otp_screen.dart';
import 'package:molita_flutter/views/orang_tua/ChatBot/chat_bot_view.dart';
import 'package:molita_flutter/views/orang_tua/Menu/menu_view.dart';
import 'package:molita_flutter/views/orang_tua/Onboarding/onboarding_view.dart';
import 'package:molita_flutter/views/orang_tua/Onboarding/splash_screen_view.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => SplashScreenView(),
    '/onboarding': (context) => OnboardingView(),
    '/login': (context) => LoginView(),
    '/register': (context) => RegisterView(),
    '/orang_tua': (context) => MenuView(),
    '/chat-bot': (context) => ChatBotView(),
    '/lupa-password':
        (context) => LupaPasswordScreen(),
  };
}
