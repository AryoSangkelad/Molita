import 'package:flutter/material.dart';
import 'package:molita_flutter/utils/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, "/onboarding");
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          Center(
            child: Image.asset('assets/images/molita.png', height: 200),
          ),

          const Spacer(),

          Column(
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'OleoScript',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Mo',
                      style: TextStyle(
                        color: AppColors.brightBlue
                      ),
                    ),
                    TextSpan(
                      text: 'lita',
                      style: TextStyle(
                        color: AppColors.softPink
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Powered by Molita team',
                style: TextStyle(),
              ),
              const SizedBox(height: 32), // Jarak dari bawah layar
            ],
          )
        ],
      ),
    );
  }
}
