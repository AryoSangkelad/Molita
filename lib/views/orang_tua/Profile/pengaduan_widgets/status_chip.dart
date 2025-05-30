import 'package:flutter/material.dart';

Widget buildStatusChip(String status) {
  Color backgroundColor;
  Color textColor;

  switch (status.toLowerCase()) {
    case 'selesai':
      backgroundColor = Colors.green[100]!;
      textColor = Colors.green[800]!;
      break;
    case 'diproses':
      backgroundColor = Colors.orange[100]!;
      textColor = Colors.orange[800]!;
      break;
    default:
      backgroundColor = Colors.grey[200]!;
      textColor = Colors.grey[800]!;
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    ),
  );
}
