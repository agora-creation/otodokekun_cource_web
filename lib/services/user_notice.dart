import 'package:cloud_firestore/cloud_firestore.dart';

class UserNoticeService {
  String _collection = 'user';
  String _subCollection = 'notice';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String getNewNoticeId({String userId}) {
    String id = _firebaseFirestore
        .collection(_collection)
        .doc(userId)
        .collection(_subCollection)
        .doc()
        .id;
    return id;
  }

  void createNotice(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['userId'])
        .collection(_subCollection)
        .doc(values['id'])
        .set(values);
  }
}
