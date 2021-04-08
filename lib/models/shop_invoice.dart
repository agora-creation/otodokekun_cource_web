import 'package:cloud_firestore/cloud_firestore.dart';

class ShopInvoiceModel {
  String _id;
  String _shopId;
  DateTime _openedAt;
  DateTime _closedAt;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  DateTime get openedAt => _openedAt;
  DateTime get closedAt => _closedAt;
  DateTime get createdAt => _createdAt;

  ShopInvoiceModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _openedAt = snapshot.data()['openedAt'].toDate();
    _closedAt = snapshot.data()['closedAt'].toDate();
    _createdAt = snapshot.data()['createdAt'].toDate();
  }

  ShopInvoiceModel.toNull() {
    _id = '';
    _shopId = '';
    _openedAt = DateTime(DateTime.now().year - 1);
    _closedAt = DateTime(DateTime.now().year + 1);
    _createdAt = DateTime.now();
  }
}
