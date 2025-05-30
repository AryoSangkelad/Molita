import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

Widget buildDetailItemHtml({
  required String title,
  required String content,
  bool isLast = false,
}) {
  print(content);
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
        Html(
          data: content,
          style: {
            "body": Style(
              fontSize: FontSize(16),
              color: Colors.grey[800],
              margin: Margins.all(0),
              padding: HtmlPaddings.all(0),
            ),
          },
        ),
      ],
    ),
  );
}
