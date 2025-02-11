import 'package:flutter/material.dart';
import 'package:connect_if/ui/themes/class_themes.dart';

class MyTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        // border when unselected
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppThemeCustom.gray400,
          ),
          borderRadius: BorderRadius.circular(12),
        ),

        // border when selected
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppThemeCustom.green500,
          ),
          borderRadius: BorderRadius.circular(12),
        ),

        hintText: hintText,
        hintStyle: TextStyle(
          color: AppThemeCustom.black,
        ),
        // fillColor: AppThemeCustom.black,
        filled: true,
      ),
    );
  }
}