import 'package:cloud_firestore/cloud_firestore.dart';

class DaysModel {
  String id;
  String name;
  String image;
  String unit;
  int price;
  DateTime deliveryAt;

  DaysModel.fromMap(Map data) {
    id = data['id'];
    name = data['name'];
    image = data['image'];
    unit = data['unit'];
    price = data['price'];
    deliveryAt = data['deliveryAt'].toDate();
  }

  Map toMap() => {
        'id': id,
        'name': name,
        'image': image,
        'unit': unit,
        'price': price,
        'deliveryAt': deliveryAt,
      };
}

List<DaysModel> createDays(DateTime openedAt, DateTime closedAt) {
  List<DaysModel> days = [];
  for (int i = 0; i <= closedAt.difference(openedAt).inDays; i++) {
    Map day = {
      'id': '',
      'name': '',
      'image': '',
      'unit': '',
      'price': 0,
      'deliveryAt': Timestamp.fromDate(openedAt.add(Duration(days: i))),
    };
    days.add(DaysModel.fromMap(day));
  }
  return days;
}
