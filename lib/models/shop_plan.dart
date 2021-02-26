import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ShopPlanModel {
  String _id;
  String _shopId;
  String _name;
  String _image;
  String _unit;
  int _price;
  String _description;
  DateTime _deliveryAt;
  bool _published;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  String get name => _name;
  String get image => _image;
  String get unit => _unit;
  int get price => _price;
  String get description => _description;
  DateTime get deliveryAt => _deliveryAt;
  bool get published => _published;
  DateTime get createdAt => _createdAt;

  ShopPlanModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _name = snapshot.data()['name'];
    _image = snapshot.data()['image'];
    _unit = snapshot.data()['unit'];
    _price = snapshot.data()['price'];
    _description = snapshot.data()['description'];
    _deliveryAt = snapshot.data()['deliveryAt'].toDate();
    _published = snapshot.data()['published'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'shopId': shopId,
        'name': name,
        'image': image,
        'unit': unit,
        'price': price,
        'description': description,
        'deliveryAt': deliveryAt,
        'deliveryAtText': DateFormat('yyyy/MM/dd HH:mm').format(deliveryAt),
        'published': published,
        'publishedText': published ? '公開' : '非公開',
        'createdAt': createdAt,
        'createdAtText': DateFormat('yyyy/MM/dd HH:mm').format(createdAt),
      };
}
