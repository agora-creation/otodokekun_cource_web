import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_product.dart';
import 'package:otodokekun_cource_web/services/shop_product.dart';

class ShopProductProvider with ChangeNotifier {
  ShopProductService _shopProductService = ShopProductService();
  bool isLoading = false;

  TextEditingController name = TextEditingController();

  Future<bool> createProduct({String shopId}) async {
    if (name.text == null) return false;
    String productId = _shopProductService.getNewProductId(shopId: shopId);
    try {
      _shopProductService.createProduct({
        'id': productId,
        'shopId': shopId,
        'name': name.text.trim(),
        'image': '',
        'unit': '',
        'price': 0,
        'description': '',
        'published': true,
        'createdAt': DateTime.now(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateProduct({String id, String shopId}) async {
    if (name.text == null) return false;
    try {
      _shopProductService.updateProduct({
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

  Future<bool> deleteProduct({String id, String shopId}) async {
    try {
      _shopProductService.deleteProduct({
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

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getProducts({String shopId}) async {
    List<Map<String, dynamic>> _source = [];
    await _shopProductService.getProducts(shopId: shopId).then((value) {
      for (ShopProductModel _product in value) {
        _source.add(_product.toMap());
      }
    });
    return _source;
  }
}