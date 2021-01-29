import 'package:cloud_firestore/cloud_firestore.dart';

class ShopNoticeService {
  String _collection = 'shop';
  String _subCollection = 'notice';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String getNewNoticeId({String shopId}) {
    String id = _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .doc()
        .id;
    return id;
  }

  void createNotice(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .set(values);
  }

  void updateUser(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .update(values);
  }

  void deleteUser(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .delete();
  }

  Future<List<Map<String, dynamic>>> getNoticesList({String shopId}) async {
    List<Map<String, dynamic>> notices = [];
    if (shopId != null) {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection(_collection)
          .doc(shopId)
          .collection(_subCollection)
          .orderBy('createdAt', descending: true)
          .get();
      for (DocumentSnapshot notice in snapshot.docs) {
        notices.add(notice.data());
      }
    }
    return notices;
  }
}
