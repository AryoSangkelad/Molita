
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildLoadingState(Color weightColor) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(weightColor),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Memuat data pertumbuhan...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }