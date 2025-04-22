import 'package:flutter/material.dart';
import 'package:molita_flutter/View/login/login_page.dart';
import 'package:molita_flutter/View/onboarding/onboarding_page.dart';
import 'package:molita_flutter/View/onboarding/splash_screen.dart';
import 'package:molita_flutter/View/register/register_page.dart';
import 'package:molita_flutter/view/dashboard/dashboard_page.dart';
import 'package:molita_flutter/viewmodels/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:molita_flutter/viewmodels/login_viewmodel.dart';
import 'package:molita_flutter/viewmodels/register_viewmodel.dart';


void main() {
  runApp(const MolitaApp());
}

class MolitaApp extends StatelessWidget {
  const MolitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),

      ],
      child: MaterialApp(
        title: 'Molita',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => OnboardingPage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => DashboardPage(),
        },
      ),
    );
  }
}
