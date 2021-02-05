import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_course.dart';
import 'package:otodokekun_cource_web/services/shop_course.dart';

class ShopCourseProvider with ChangeNotifier {
  ShopCourseService _shopCourseService = ShopCourseService();
  bool isLoading = false;

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
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());
      notifyListeners();
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
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCourse({String id, String shopId}) async {
    try {
      _shopCourseService.deleteCourse({
        'id': id,
        'shopId': shopId,
      });
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());
      notifyListeners();
      return false;
    }
  }

  void clearController() {
    name.text = '';
  }

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getCourses({String shopId}) async {
    List<Map<String, dynamic>> _source = [];
    await _shopCourseService.getCourses(shopId: shopId).then((value) {
      for (ShopCourseModel _course in value) {
        _source.add(_course.toMap());
      }
    });
    return _source;
  }
}
