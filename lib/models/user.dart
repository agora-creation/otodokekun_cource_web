import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String _id;
  String _shopId;
  String _name;
  String _zip;
  String _address;
  String _tel;
  String _email;
  String _password;
  bool _blacklist;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  String get name => _name;
  String get zip => _zip;
  String get address => _address;
  String get tel => _tel;
  String get email => _email;
  String get password => _password;
  bool get blacklist => _blacklist;
  DateTime get createdAt => _createdAt;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _name = snapshot.data()['name'];
    _zip = snapshot.data()['zip'];
    _address = snapshot.data()['address'];
    _tel = snapshot.data()['tel'];
    _email = snapshot.data()['email'];
    _password = snapshot.data()['password'];
    _blacklist = snapshot.data()['blacklist'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'shopId': shopId,
        'name': name,
        'zip': zip,
        'address': address,
        'tel': tel,
        'email': email,
        'password': password,
        'blacklist': blacklist,
        'createdAt': createdAt,
      };
}
