import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource_web/models/cart.dart';

class ShopOrderModel {
  String _id;
  String _shopId;
  String _userId;
  String _userName;
  String _userZip;
  String _userAddress;
  String _userTel;
  List<CartModel> cart;
  DateTime _deliveryAt;
  String _remarks;
  int _totalPrice;
  String _staff;
  bool _shipping;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  String get userId => _userId;
  String get userName => _userName;
  String get userZip => _userZip;
  String get userAddress => _userAddress;
  String get userTel => _userTel;
  DateTime get deliveryAt => _deliveryAt;
  String get remarks => _remarks;
  int get totalPrice => _totalPrice;
  String get staff => _staff;
  bool get shipping => _shipping;
  DateTime get createdAt => _createdAt;

  ShopOrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _userId = snapshot.data()['userId'];
    _userName = snapshot.data()['userName'];
    _userZip = snapshot.data()['userZip'];
    _userAddress = snapshot.data()['userAddress'];
    _userTel = snapshot.data()['userTel'];
    cart = _convertCart(snapshot.data()['cart']) ?? [];
    _deliveryAt = snapshot.data()['deliveryAt'].toDate();
    _remarks = snapshot.data()['remarks'];
    _totalPrice = snapshot.data()['totalPrice'];
    _staff = snapshot.data()['staff'];
    _shipping = snapshot.data()['shipping'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }

  List<CartModel> _convertCart(List cart) {
    List<CartModel> convertedCart = [];
    for (Map data in cart) {
      convertedCart.add(CartModel.fromMap(data));
    }
    return convertedCart;
  }
}
