import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/services/shop_order.dart';

class ShopOrderProvider with ChangeNotifier {
  ShopOrderService _shopOrderService = ShopOrderService();

  String staff;
  bool shipping;

  Future<bool> updateOrder({String id, String shopId}) async {
    try {
      _shopOrderService.updateOrder({
        'id': id,
        'shopId': shopId,
        'staff': staff,
        'shipping': shipping,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
