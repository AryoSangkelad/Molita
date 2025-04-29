import 'package:flutter/material.dart';

Widget buildJadwalPosyandu() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      color: const Color(0xFF2196F3),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_hospital, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  "Posyandu Melati 29",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  "Senin, 2 Desember 2024",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.white),
                SizedBox(width: 12),
                Text("08:10 - 10:30", style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
