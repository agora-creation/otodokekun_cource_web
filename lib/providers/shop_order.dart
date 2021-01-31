import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_order.dart';
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

  void clearController() {}

  Future<List<Map<String, dynamic>>> getOrdersSource({String shopId}) async {
    List<Map<String, dynamic>> source = [];
    List<ShopOrderModel> orders = [];
    orders = await _shopOrderService.getOrders(shopId: shopId);
    for (ShopOrderModel order in orders) {
      source.add(order.toMap());
    }
    return source;
  }
}
