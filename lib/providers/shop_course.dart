import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/days.dart';
import 'package:otodokekun_cource_web/services/shop_course.dart';

class ShopCourseProvider with ChangeNotifier {
  ShopCourseService _shopCourseService = ShopCourseService();

  TextEditingController name = TextEditingController();
  bool published;

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

  Future<bool> updateCourse(
      {String id, String shopId, List<DaysModel> days}) async {
    if (name.text == null) return false;
    List<Map> convertedDays = [];
    for (DaysModel day in days) {
      convertedDays.add(day.toMap());
    }
    try {
      _shopCourseService.updateCourse({
        'id': id,
        'shopId': shopId,
        'name': name.text.trim(),
        'days': convertedDays,
        'published': published,
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
