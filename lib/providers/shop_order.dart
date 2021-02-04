import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/services/shop_order.dart';

class ShopOrderProvider with ChangeNotifier {
  ShopOrderService _shopOrderService = ShopOrderService();

  Future<bool> updateOrder({String id, String shopId}) async {
    try {
      _shopOrderService.updateOrder({
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
