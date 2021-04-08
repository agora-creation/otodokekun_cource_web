import 'package:cloud_firestore/cloud_firestore.dart';

class ShopProductRegularModel {
  String _id;
  String _shopId;
  String _productId;
  String _productName;
  String _productImage;
  String _productUnit;
  int _productPrice;
  String _productDescription;
  DateTime _deliveryAt;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  String get productId => _productId;
  String get productName => _productName;
  String get productImage => _productImage;
  String get productUnit => _productUnit;
  int get productPrice => _productPrice;
  String get productDescription => _productDescription;
  DateTime get deliveryAt => _deliveryAt;
  DateTime get createdAt => _createdAt;

  ShopProductRegularModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _productId = snapshot.data()['productId'];
    _productName = snapshot.data()['productName'];
    _productImage = snapshot.data()['productImage'];
    _productUnit = snapshot.data()['productUnit'];
    _productPrice = snapshot.data()['productPrice'];
    _productDescription = snapshot.data()['productDescription'];
    _deliveryAt = snapshot.data()['deliveryAt'].toDate();
    _createdAt = snapshot.data()['createdAt'].toDate();
  }
}
