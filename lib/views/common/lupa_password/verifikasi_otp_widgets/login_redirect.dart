import 'package:flutter/material.dart';

Widget buildLoginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Ingat Password anda?", style: TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, "/login"),
          child: Text(
            "Masuk",
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }