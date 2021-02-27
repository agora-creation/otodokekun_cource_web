import 'package:cloud_firestore/cloud_firestore.dart';

class ShopOrderService {
  String _collection = 'shop';
  String _subCollection = 'order';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .update(values);
  }
}
