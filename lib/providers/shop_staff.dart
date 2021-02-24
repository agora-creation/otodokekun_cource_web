import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_staff.dart';
import 'package:otodokekun_cource_web/services/shop_staff.dart';

class ShopStaffProvider with ChangeNotifier {
  ShopStaffService _shopStaffService = ShopStaffService();

  TextEditingController name = TextEditingController();

  Future<bool> createStaff({String shopId}) async {
    if (name.text == null) return false;
    String staffId = _shopStaffService.getNewStaffId(shopId: shopId);
    try {
      _shopStaffService.createStaff({
        'id': staffId,
        'shopId': shopId,
        'name': name.text.trim(),
        'createdAt': DateTime.now(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateStaff({String id, String shopId}) async {
    if (name.text == null) return false;
    try {
      _shopStaffService.updateStaff({
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

  Future<bool> deleteStaff({String id, String shopId}) async {
    try {
      _shopStaffService.deleteStaff({
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

  Future<List<ShopStaffModel>> getStaffs({String shopId}) async {
    List<ShopStaffModel> _staffs = [];
    await _shopStaffService.getStaffs(shopId: shopId).then((value) {
      _staffs = value;
    });
    return _staffs;
  }
}
