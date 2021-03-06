import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource_web/models/user.dart';

class UserService {
  String _collection = 'user';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).update(values);
  }

  Future<List<UserModel>> selectList({String shopId}) async {
    List<UserModel> _users = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .where('shopId', isEqualTo: shopId)
        .orderBy('createdAt', descending: true)
        .get();
    for (DocumentSnapshot _user in snapshot.docs) {
      _users.add(UserModel.fromSnapshot(_user));
    }
    return _users;
  }

  Future<List<UserModel>> selectListNotice(
      {String noticeId, String shopId}) async {
    List<UserModel> _users = [];
    QuerySnapshot userSnapshot = await _firebaseFirestore
        .collection(_collection)
        .where('shopId', isEqualTo: shopId)
        .orderBy('createdAt', descending: true)
        .get();
    for (DocumentSnapshot _user in userSnapshot.docs) {
      DocumentSnapshot noticeSnapshot = await _firebaseFirestore
          .collection(_collection)
          .doc(UserModel.fromSnapshot(_user).id)
          .collection('notice')
          .doc(noticeId)
          .get();
      if (noticeSnapshot.exists == false) {
        _users.add(UserModel.fromSnapshot(_user));
      }
    }
    return _users;
  }

  Future<List<UserModel>> selectListRegular({String shopId}) async {
    List<UserModel> _users = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .where('shopId', isEqualTo: shopId)
        .where('regular', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();
    for (DocumentSnapshot _user in snapshot.docs) {
      _users.add(UserModel.fromSnapshot(_user));
    }
    return _users;
  }
}
