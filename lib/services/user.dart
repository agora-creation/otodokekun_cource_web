import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  String _collection = 'user';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void createUser(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).set(values);
  }

  void updateUser(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).update(values);
  }

  void deleteUser(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).delete();
  }

  Future<List<Map<String, dynamic>>> getUsersList({String shopId}) async {
    List<Map<String, dynamic>> users = [];
    if (shopId != null) {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection(_collection)
          .where('shopId', isEqualTo: shopId)
          .orderBy('createdAt', descending: true)
          .get();
      for (DocumentSnapshot user in snapshot.docs) {
        users.add(user.data());
      }
    }
    return users;
  }
}
