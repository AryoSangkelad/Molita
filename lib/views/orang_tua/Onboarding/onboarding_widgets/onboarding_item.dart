import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:molita_flutter/models/common/onboarding_model.dart';

class OnboardingItem extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(model.imageAsset, height: 200),
        SizedBox(height: 24),
        Text(
          model.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            model.description,
            style: TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

Widget buildOnboardingItem(OnboardingModel model, double screenHeight) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Lottie animation
        Container(
          height: model.animation ? screenHeight * 0.4 : screenHeight * 0.27,
          child:
              model.animation
                  ? Lottie.asset(
                    'assets/animations/${model.imageAsset}',
                    fit: BoxFit.contain,
                  )
                  : Image.asset(
                    'assets/images/${model.imageAsset}',
                    fit: BoxFit.contain,
                  ),
        ),
        SizedBox(height: 40),

        // Title
        Text(
          model.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
            height: 1.2,
          ),
        ),
        SizedBox(height: 16),

        // Description
        Text(
          model.description,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}
