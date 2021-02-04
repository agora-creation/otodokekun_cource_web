import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource_web/models/shop_notice.dart';

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

  void updateNotice(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .update(values);
  }

  void deleteNotice(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .delete();
  }

  Future<List<ShopNoticeModel>> getNotices({String shopId}) async {
    List<ShopNoticeModel> _notices = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .orderBy('createdAt', descending: true)
        .get();
    for (DocumentSnapshot _notice in snapshot.docs) {
      _notices.add(ShopNoticeModel.fromSnapshot(_notice));
    }
    return _notices;
  }
}
