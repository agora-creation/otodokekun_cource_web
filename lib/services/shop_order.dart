import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource_web/models/shop_order.dart';

class ShopOrderService {
  String _collection = 'shop';
  String _subCollection = 'order';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void updateOrder(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .update(values);
  }

  Future<List<ShopOrderModel>> getOrders({String shopId}) async {
    List<ShopOrderModel> orders = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .orderBy('createdAt', descending: true)
        .get();
    for (DocumentSnapshot order in snapshot.docs) {
      orders.add(ShopOrderModel.fromSnapshot(order));
    }
    return orders;
  }
}
