import 'package:flutter/material.dart';

Widget buildChip(String label, Color color) {
  return Chip(
    label: Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
    backgroundColor: color,
    padding: EdgeInsets.symmetric(horizontal: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
