import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaysListTile extends StatelessWidget {
  final DateTime deliveryAt;

  DaysListTile({this.deliveryAt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
        ),
        child: ListTile(
          leading: Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black54.withOpacity(0.3),
            ),
            child: Center(
                child: Text('${DateFormat('MM/dd').format(deliveryAt)}')),
          ),
          title: Text('商品選択'),
          trailing: Icon(Icons.arrow_drop_down_circle),
          contentPadding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }
}
