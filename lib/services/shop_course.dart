import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource_web/models/shop_course.dart';

class ShopCourseService {
  String _collection = 'shop';
  String _subCollection = 'course';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String getNewCourseId({String shopId}) {
    String id = _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .doc()
        .id;
    return id;
  }

  void createCourse(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .set(values);
  }

  void updateCourse(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .update(values);
  }

  void deleteCourse(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .delete();
  }

  Future<List<ShopCourseModel>> getCourses({String shopId}) async {
    List<ShopCourseModel> courses = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .orderBy('createdAt', descending: true)
        .get();
    for (DocumentSnapshot course in snapshot.docs) {
      courses.add(ShopCourseModel.fromSnapshot(course));
    }
    return courses;
  }
}
