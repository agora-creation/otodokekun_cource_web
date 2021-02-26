import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  String _id;
  String _code;
  String _name;
  String _zip;
  String _address;
  String _tel;
  String _email;
  String _password;
  String _remarks;
  int _invoiceLimit;
  int _cancelLimit;
  DateTime _createdAt;

  String get id => _id;
  String get code => _code;
  String get name => _name;
  String get zip => _zip;
  String get address => _address;
  String get tel => _tel;
  String get email => _email;
  String get password => _password;
  String get remarks => _remarks;
  int get invoiceLimit => _invoiceLimit;
  int get cancelLimit => _cancelLimit;
  DateTime get createdAt => _createdAt;

  ShopModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _code = snapshot.data()['code'];
    _name = snapshot.data()['name'];
    _zip = snapshot.data()['zip'];
    _address = snapshot.data()['address'];
    _tel = snapshot.data()['tel'];
    _email = snapshot.data()['email'];
    _password = snapshot.data()['password'];
    _remarks = snapshot.data()['remarks'];
    _invoiceLimit = snapshot.data()['invoiceLimit'];
    _cancelLimit = snapshot.data()['cancelLimit'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }
}
