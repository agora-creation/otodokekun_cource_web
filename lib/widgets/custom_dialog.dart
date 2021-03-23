import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  CustomDialog({
    this.title,
    this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      content: content,
      contentPadding: EdgeInsets.all(16.0),
      actions: actions,
    );
  }
}
