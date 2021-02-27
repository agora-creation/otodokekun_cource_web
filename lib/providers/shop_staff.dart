import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_staff.dart';
import 'package:otodokekun_cource_web/services/shop_staff.dart';

class ShopStaffProvider with ChangeNotifier {
  ShopStaffService _shopStaffService = ShopStaffService();

  TextEditingController name = TextEditingController();

  Future<bool> create({String shopId}) async {
    if (name.text == null) return false;
    String id = _shopStaffService.newId(shopId: shopId);
    try {
      _shopStaffService.create({
        'id': id,
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

  Future<bool> update({String id, String shopId}) async {
    if (name.text == null) return false;
    try {
      _shopStaffService.update({
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

  Future<bool> delete({String id, String shopId}) async {
    try {
      _shopStaffService.delete({
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

  Future<List<ShopStaffModel>> selectList({String shopId}) async {
    List<ShopStaffModel> _staffs = [];
    await _shopStaffService.selectList(shopId: shopId).then((value) {
      _staffs = value;
    });
    return _staffs;
  }
}
