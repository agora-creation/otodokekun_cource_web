import 'package:flutter/material.dart';

class LinkButton extends StatelessWidget {
  final String labelText;
  final Function onTap;

  LinkButton({
    this.labelText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        labelText,
        style: TextStyle(
          color: Colors.blueAccent,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
