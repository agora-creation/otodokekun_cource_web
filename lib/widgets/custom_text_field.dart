import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String labelText;
  final IconData iconData;

  CustomTextField({
    this.controller,
    this.obscureText,
    this.labelText,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: kMainColor,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(iconData, color: kMainColor),
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: kMainColor),
        ),
        labelStyle: TextStyle(color: kMainColor),
        focusColor: kMainColor,
      ),
    );
  }
}
