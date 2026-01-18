import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grouptalk/core/theme/app_colors.dart';

Widget inputField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool obscure = false,
}) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    decoration: InputDecoration(
      filled: true,
      fillColor: AppColors.white,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      )
    ),
  );
}
