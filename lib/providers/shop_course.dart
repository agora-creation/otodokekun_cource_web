import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/days.dart';
import 'package:otodokekun_cource_web/models/shop_course.dart';
import 'package:otodokekun_cource_web/services/shop_course.dart';

class ShopCourseProvider with ChangeNotifier {
  ShopCourseService _shopCourseService = ShopCourseService();

  TextEditingController name = TextEditingController();

  Future<bool> createCourse(
      {String shopId,
      DateTime openedAt,
      DateTime closedAt,
      List<DaysModel> days}) async {
    if (name.text == null) return false;
    String courseId = _shopCourseService.getNewCourseId(shopId: shopId);
    List<Map> convertedDays = [];
    for (DaysModel day in days) {
      convertedDays.add(day.toMap());
    }
    try {
      _shopCourseService.createCourse({
        'id': courseId,
        'shopId': shopId,
        'name': name.text.trim(),
        'openedAt': openedAt,
        'closedAt': closedAt,
        'days': convertedDays,
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
