import 'package:flutter/material.dart';

Widget buildInputField({
  required String label,
  required String hint,
  required FormFieldValidator<String> validator,
  required FormFieldSetter<String> onSaved,
  int maxLines = 1,
  String? initialValue, // Tambahkan parameter initialValue
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
      SizedBox(height: 8),
      TextFormField(
        initialValue: initialValue, // Gunakan initialValue di sini
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: validator,
        onSaved: onSaved,
        maxLines: maxLines,
      ),
    ],
  );
}
