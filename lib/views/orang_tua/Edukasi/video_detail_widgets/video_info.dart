  import 'package:flutter/material.dart';

Widget buildVideoInfo(TextTheme textTheme, String judul) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          judul,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }