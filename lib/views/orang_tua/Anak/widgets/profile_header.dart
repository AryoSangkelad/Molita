import 'package:flutter/material.dart';

Widget buildProfileHeader(String nama) {
  return Container(
    width: double.infinity, // Full width

    padding: const EdgeInsets.symmetric(vertical: 24),
    decoration: BoxDecoration(
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.person, size: 40, color: Colors.blue[800]),
        ),
        const SizedBox(height: 16),
        Text(
          nama,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Profil Anak",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
