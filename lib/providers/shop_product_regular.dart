import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_product.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/services/shop_order.dart';
import 'package:otodokekun_cource_web/services/shop_product_regular.dart';

class ShopProductRegularProvider with ChangeNotifier {
  ShopOrderService _shopOrderService = ShopOrderService();
  ShopProductRegularService _shopProductRegularService =
      ShopProductRegularService();

  Future<bool> create(
      {String shopId,
      DateTime deliveryAt,
      ShopProductModel product,
      List<UserModel> users}) async {
    if (deliveryAt == null) return false;
    if (product == null) return false;
    String id = _shopProductRegularService.newId(shopId: shopId);
    try {
      _shopProductRegularService.create({
        'id': id,
        'shopId': shopId,
        'productId': product.id,
        'productName': product.name,
        'productImage': product.image,
        'productUnit': product.unit,
        'productPrice': product.price,
        'productDescription': product.description,
        'deliveryAt': deliveryAt,
        'createdAt': DateTime.now(),
      });
      for (UserModel _user in users) {
        String orderId = _shopOrderService.newId(shopId: shopId);
        List<Map> cart = [];
        cart.add({
          'id': '',
          'name': '',
          'image': '',
          'unit': '',
          'price': 0,
          'quantity': 1,
          'totalPrice': 0,
        });
        _shopOrderService.create({
          'id': orderId,
          'shopId': shopId,
          'userId': _user.id,
          'userName': _user.name,
          'userZip': _user.zip,
          'userAddress': _user.address,
          'userTel': _user.tel,
          'cart': cart,
          'deliveryAt': deliveryAt,
          'remarks': '',
          'totalPrice': 0,
          'staff': _user.staff,
          'shipping': false,
          'createdAt': deliveryAt,
        });
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> delete({String id, String shopId}) async {
    try {
      _shopProductRegularService.delete({
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
