import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource_web/models/shop_invoice.dart';

class ShopInvoiceService {
  String _collection = 'shop';
  String _subCollection = 'invoice';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String newId({String shopId}) {
    String id = _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .doc()
        .id;
    return id;
  }

  void create(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .set(values);
  }

  void update(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .update(values);
  }

  void delete(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .delete();
  }

  Future<List<ShopInvoiceModel>> selectList({String shopId}) async {
    List<ShopInvoiceModel> _invoices = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .orderBy('openedAt', descending: true)
        .get();
    for (DocumentSnapshot _invoice in snapshot.docs) {
      _invoices.add(ShopInvoiceModel.fromSnapshot(_invoice));
    }
    return _invoices;
  }
}
