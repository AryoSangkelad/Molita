import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

Widget buildDescriptionSection(TextTheme textTheme, String deskripsi) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Deskripsi Video',
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.grey[800],
        ),
      ),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Html(
          data: deskripsi,
          style: {
            "body": Style(
              color: Colors.grey[700],
              fontSize: FontSize.medium,
              lineHeight: LineHeight.number(1.5),
            ),
          },
        ),
      ),
    ],
  );
}
