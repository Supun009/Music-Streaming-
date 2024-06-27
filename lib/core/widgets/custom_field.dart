import 'package:flutter/material.dart';

class CustomFied extends StatelessWidget {
  final TextEditingController? controller;
  final bool obscureText;
  final String? hintText;
  final bool readonly;
  final VoidCallback? onTap;
  const CustomFied({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.readonly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readonly,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText is missing!";
        }
        return null;
      },
    );
  }
}
