import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/services/shop_course.dart';

class ShopCourseProvider with ChangeNotifier {
  ShopCourseService _shopCourseService = ShopCourseService();

  TextEditingController name = TextEditingController();

  Future<bool> createCourse({String shopId}) async {
    if (name.text == null) return false;
    String courseId = _shopCourseService.getNewCourseId(shopId: shopId);
    try {
      _shopCourseService.createCourse({
        'id': courseId,
        'shopId': shopId,
        'name': name.text.trim(),
        'openedAt': DateTime.now(),
        'closedAt': DateTime.now(),
        'days': [],
        'published': true,
        'createdAt': DateTime.now(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateCourse({String id, String shopId}) async {
    if (name.text == null) return false;
    try {
      _shopCourseService.updateCourse({
        'id': id,
        'shopId': shopId,
        'name': name.text.trim(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteCourse({String id, String shopId}) async {
    try {
      _shopCourseService.deleteCourse({
        'id': id,
        'shopId': shopId,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void clearController() {
    name.text = '';
  }
}
