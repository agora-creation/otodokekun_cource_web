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

  Future<List<UserModel>> selectListFixed({String shopId}) async {
    List<UserModel> _users = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .where('shopId', isEqualTo: shopId)
        .where('fixed', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();
    for (DocumentSnapshot _user in snapshot.docs) {
      _users.add(UserModel.fromSnapshot(_user));
    }
    return _users;
  }
}
