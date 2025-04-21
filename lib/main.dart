import 'package:flutter/material.dart';
import 'View/onboarding/onboarding_page.dart';
import 'View/onboarding/splash_screen.dart';

void main() {
  runApp(MolitaApp());
}

class MolitaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Molita',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingPage(),
        '/home': (context) => Scaffold(body: Center(child: Text('Home Screen'))),
      },
    );
  }
}
