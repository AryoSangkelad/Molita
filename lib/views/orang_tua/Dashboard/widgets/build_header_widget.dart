import 'package:flutter/material.dart';

Widget buildHeader(BuildContext context, String name) {
  return Container(
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    decoration: const BoxDecoration(
      color: Color(0xFF1976D2),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Hai, ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: "$name!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[200],
                  ),
                ),
              ],
            ),
          ),
          Text(
            "Yuk, pastikan kesehatan anak terjamin!",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari informasi atau layanan...',
              hintStyle: TextStyle(color: Colors.white60),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}
