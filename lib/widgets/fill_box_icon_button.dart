import 'package:flutter/material.dart';

class FillBoxIconButton extends StatelessWidget {
  final IconData iconData;
  final String labelText;
  final Color labelColor;
  final Color backgroundColor;
  final Function onTap;

  FillBoxIconButton({
    this.iconData,
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
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                iconData,
                size: 16.0,
                color: labelColor,
              ),
              SizedBox(width: 8.0),
              Text(
                labelText,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
