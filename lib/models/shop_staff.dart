import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ShopStaffModel {
  String _id;
  String _shopId;
  String _name;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  String get name => _name;
  DateTime get createdAt => _createdAt;

  ShopStaffModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _name = snapshot.data()['name'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'shopId': shopId,
        'name': name,
        'createdAt': createdAt,
        'createdAtText': DateFormat('yyyy/MM/dd HH:mm').format(createdAt),
      };
}
