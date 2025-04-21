import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, "/onboarding");
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/molita.png', height: 200),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'OleoScript',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                children: const [
                  TextSpan(
                    text: 'Mo',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: 'lita',
                    style: TextStyle(color: Colors.amber),
                  ),
                ],
              ),
            ),

            Text(
              'Powered by Molita team',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
