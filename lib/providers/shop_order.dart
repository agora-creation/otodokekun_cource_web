import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_order.dart';
import 'package:otodokekun_cource_web/services/shop_order.dart';

class ShopOrderProvider with ChangeNotifier {
  ShopOrderService _shopOrderService = ShopOrderService();

  Future<bool> updateOrder({String id, String shopId, bool shipping}) async {
    try {
      _shopOrderService.updateOrder({
        'id': id,
        'shopId': shopId,
        'shipping': !shipping,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getOrders({String shopId}) async {
    List<Map<String, dynamic>> _source = [];
    await _shopOrderService.getOrders(shopId: shopId).then((value) {
      for (ShopOrderModel _order in value) {
        _source.add(_order.toMap());
      }
    });
    return _source;
  }
}
