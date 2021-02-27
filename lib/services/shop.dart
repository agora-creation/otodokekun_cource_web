import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource_web/models/shop.dart';

class ShopService {
  String _collection = 'shop';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void create(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).update(values);
  }

  Future<ShopModel> select({String shopId}) async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection(_collection).doc(shopId).get();
    return ShopModel.fromSnapshot(snapshot);
  }
}
