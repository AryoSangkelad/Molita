import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/colors_constant.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, "/onboarding");
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE1F5FE), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
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
                          style: TextStyle(color: ColorsConstant.brightBlue),
                        ),
                        TextSpan(
                          text: 'lita',
                          style: TextStyle(color: ColorsConstant.softPink),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Powered by Molita team', style: TextStyle()),
                  const SizedBox(height: 32), // Jarak dari bawah layar
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
