import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ShopNoticeModel {
  String _id;
  String _shopId;
  String _title;
  String _message;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  String get title => _title;
  String get message => _message;
  DateTime get createdAt => _createdAt;

  ShopNoticeModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _title = snapshot.data()['title'];
    _message = snapshot.data()['message'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'shopId': shopId,
        'title': title,
        'message': message,
        'createdAt': createdAt,
        'createdAtText': DateFormat('yyyy/MM/dd HH:mm').format(createdAt),
      };
}
