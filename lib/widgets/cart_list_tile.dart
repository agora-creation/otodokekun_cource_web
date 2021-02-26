import 'package:flutter/material.dart';

class CartListTile extends StatelessWidget {
  final String name;
  final String image;
  final String unit;
  final int price;
  final int quantity;

  CartListTile({
    this.name,
    this.image,
    this.unit,
    this.price,
    this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
        ),
        child: ListTile(
          leading: image != ''
              ? Image.network(
                  image,
                  fit: BoxFit.cover,
                )
              : null,
          title: Text(name),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('¥ $price / $unit'),
              Text('$quantity $unit'),
            ],
          ),
        ),
      ),
    );
  }
}
