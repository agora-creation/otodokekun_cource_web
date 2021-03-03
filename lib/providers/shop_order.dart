import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/services/shop_order.dart';
import 'package:otodokekun_cource_web/services/user.dart';

class ShopOrderProvider with ChangeNotifier {
  ShopOrderService _shopOrderService = ShopOrderService();
  UserService _userService = UserService();

  String staff;
  bool shipping;

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
}
