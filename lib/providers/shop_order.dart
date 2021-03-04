import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/services/shop_order.dart';
import 'package:otodokekun_cource_web/services/user.dart';

class ShopOrderProvider with ChangeNotifier {
  ShopOrderService _shopOrderService = ShopOrderService();
  UserService _userService = UserService();

  String staff;
  bool shipping;

  String searchName = '';
  DateTime searchDeliveryAt = DateTime.now();
  String searchStaff = '';
  bool searchShipping = false;

  void changeSearchDeliveryAt(DateTime dateTime) {
    searchDeliveryAt = dateTime;
    notifyListeners();
  }

  void changeSearchName(String name) {
    searchName = name;
    notifyListeners();
  }

  void changeSearchStaff(String staff) {
    searchStaff = staff;
    notifyListeners();
  }

  void changeSearchShipping(bool shipping) {
    searchShipping = shipping;
    notifyListeners();
  }

  Future<bool> update({String id, String shopId, String userId}) async {
    try {
      _shopOrderService.update({
        'id': id,
        'shopId': shopId,
        'staff': staff,
        'shipping': shipping,
      });
      _userService.update({
        'id': userId,
        'staff': staff,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> delete({String id, String shopId}) async {
    try {
      _shopOrderService.delete({
        'id': id,
        'shopId': shopId,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
