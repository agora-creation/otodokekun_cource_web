import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/services/shop_order.dart';
import 'package:otodokekun_cource_web/services/user.dart';

class ShopOrderProvider with ChangeNotifier {
  ShopOrderService _shopOrderService = ShopOrderService();
  UserService _userService = UserService();

  String staff;

  String searchName = '';
  DateTime searchDeliveryAt = DateTime.now();
  bool searchDeliveryAtDisabled = true;
  DateTime searchOpenedAt = DateTime.now();
  DateTime searchClosedAt = DateTime.now().add(Duration(days: 7));
  String searchStaff = '';
  bool searchShipping = false;

  void changeSearchName(String name) {
    searchName = name;
    notifyListeners();
  }

  void changeSearchDate(DateTime deliveryAt, bool disabled){
    searchDeliveryAt = deliveryAt;
    searchDeliveryAtDisabled = disabled;
    notifyListeners();
  }

  void changeSearchDateRage(DateTime openedAt, DateTime closedAt) {
    searchOpenedAt = openedAt;
    searchClosedAt = closedAt;
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
        'shipping': true,
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
