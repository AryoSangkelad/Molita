import 'package:flutter/material.dart';

class RegisterItem extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool isHidden;
  final VoidCallback? toggleVisibility;

  const RegisterItem({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.isHidden = true,
    this.toggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && isHidden,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isHidden ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: toggleVisibility,
          )
              : null,
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
