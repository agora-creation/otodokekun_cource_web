import 'package:cloud_firestore/cloud_firestore.dart';

class ShopProductModel {
  String _id;
  String _shopId;
  String _name;
  String _image;
  String _unit;
  int _price;
  bool _published;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  String get name => _name;
  String get image => _image;
  String get unit => _unit;
  int get price => _price;
  bool get published => _published;
  DateTime get createdAt => _createdAt;

  ShopProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _name = snapshot.data()['name'];
    _image = snapshot.data()['image'];
    _unit = snapshot.data()['unit'];
    _price = snapshot.data()['price'];
    _published = snapshot.data()['published'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }
}
