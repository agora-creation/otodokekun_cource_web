import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource_web/models/shop_product.dart';

class ShopProductService {
  String _collection = 'shop';
  String _subCollection = 'product';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String getNewProductId({String shopId}) {
    String id = _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .doc()
        .id;
    return id;
  }

  void createProduct(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .set(values);
  }

  void updateProduct(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .update(values);
  }

  void deleteProduct(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .delete();
  }

  Future<List<ShopProductModel>> getProducts({String shopId}) async {
    List<ShopProductModel> _products = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .orderBy('createdAt', descending: true)
        .get();
    for (DocumentSnapshot _product in snapshot.docs) {
      _products.add(ShopProductModel.fromSnapshot(_product));
    }
    return _products;
  }
}
