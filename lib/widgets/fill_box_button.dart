import 'package:flutter/material.dart';

class FillBoxButton extends StatelessWidget {
  final String labelText;
  final Color labelColor;
  final Color backgroundColor;
  final Function onTap;

  FillBoxButton({
    this.labelText,
    this.labelColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Text(
            labelText,
            style: TextStyle(
              color: labelColor,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
