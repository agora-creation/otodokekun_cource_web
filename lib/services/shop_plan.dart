import 'package:cloud_firestore/cloud_firestore.dart';

class ShopPlanService {
  String _collection = 'shop';
  String _subCollection = 'plan';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String getNewPlanId({String shopId}) {
    String id = _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .doc()
        .id;
    return id;
  }

  void createPlan(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .set(values);
  }

  void updatePlan(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .update(values);
  }

  void deletePlan(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .delete();
  }
}
