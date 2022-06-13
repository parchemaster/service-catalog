import 'package:flutter/material.dart';
import 'package:services_catalog/my_color.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final TextInputType? keyboardType;
  final bool obscureText;

  const MyTextField({Key? key, required this.controller, required this.hintText, required this.labelText, this.keyboardType, this.obscureText = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: MyColor.textColor),
      controller: controller,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autofocus: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: MyColor.textColor,
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: MyColor.textColor,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: MyColor.textColor),
        ),
      ),
    );
  }
}