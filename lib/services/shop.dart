import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource_web/models/shop.dart';

class ShopService {
  String _collection = 'shop';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void createShop(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).set(values);
  }

  void updateShop(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).update(values);
  }

  Future<ShopModel> getShop({String shopId}) async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection(_collection).doc(shopId).get();
    return ShopModel.fromSnapshot(snapshot);
  }
}
