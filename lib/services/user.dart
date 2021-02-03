import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource_web/models/user.dart';

class UserServices {
  String _collection = 'user';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void updateUser(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).update(values);
  }

  Future<List<UserModel>> getUsers({String shopId}) async {
    List<UserModel> users = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .where('shopId', isEqualTo: shopId)
        .orderBy('createdAt', descending: true)
        .get();
    for (DocumentSnapshot user in snapshot.docs) {
      users.add(UserModel.fromSnapshot(user));
    }
    return users;
  }
}
