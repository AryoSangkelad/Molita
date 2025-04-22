
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:molita_flutter/models/onboarding_model.dart';

 //

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
        Text(model.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            textAlign: TextAlign.center),
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
