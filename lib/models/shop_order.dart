import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/models/cart.dart';

class ShopOrderModel {
  String _id;
  String _shopId;
  String _userId;
  String _name;
  String _zip;
  String _address;
  String _tel;
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
  String get name => _name;
  String get zip => _zip;
  String get address => _address;
  String get tel => _tel;
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
    _name = snapshot.data()['name'];
    _zip = snapshot.data()['zip'];
    _address = snapshot.data()['address'];
    _tel = snapshot.data()['tel'];
    cart = _convertCart(cart: snapshot.data()['cart']) ?? [];
    _deliveryAt = snapshot.data()['deliveryAt'].toDate();
    _remarks = snapshot.data()['remarks'];
    _totalPrice = snapshot.data()['totalPrice'];
    _staff = snapshot.data()['staff'];
    _shipping = snapshot.data()['shipping'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }

  List<CartModel> _convertCart({List cart}) {
    List<CartModel> convertedCart = [];
    for (Map product in cart) {
      convertedCart.add(CartModel.fromMap(product));
    }
    return convertedCart;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'shopId': shopId,
        'userId': userId,
        'name': name,
        'zip': zip,
        'address': address,
        'tel': tel,
        'cart': cart,
        'cartText': '${cart[0].name} (${cart[0].quantity}${cart[0].unit})',
        'deliveryAt': deliveryAt,
        'deliveryAtText': DateFormat('yyyy/MM/dd').format(deliveryAt),
        'remarks': remarks,
        'totalPrice': totalPrice,
        'staff': staff,
        'shipping': shipping,
        'shippingText': shipping ? '配達済み' : '配達待ち',
        'createdAt': createdAt,
      };
}
