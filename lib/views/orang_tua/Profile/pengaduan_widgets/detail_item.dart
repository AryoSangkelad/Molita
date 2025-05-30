import 'package:flutter/material.dart';

Widget buildDetailItem({
  required String title,
  required String content,
  bool isLast = false,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(content, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
      ],
    ),
  );
}
