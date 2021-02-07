import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_product.dart';
import 'package:otodokekun_cource_web/services/shop_product.dart';

class ShopProductProvider with ChangeNotifier {
  ShopProductService _shopProductService = ShopProductService();
  var storageRef =
      fb.storage().refFromURL('gs://otodokekun-cource.appspot.com/');

  TextEditingController name = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();

  Future<bool> createProduct({String shopId, File imageFile}) async {
    if (name.text == null) return false;
    if (unit.text == null) return false;
    if (price.text == null) return false;
    String productId = _shopProductService.getNewProductId(shopId: shopId);
    String _imagePath = '$shopId/$productId';
    String _imageUrl = '';
    try {
      if (imageFile != null) {
        storageRef.child(_imagePath).put(imageFile).future.then((snapshot) {
          snapshot.ref.getDownloadURL().then((uri) {
            _imageUrl = uri.toString();
            print(_imageUrl);
          });
        });
      }
      _shopProductService.createProduct({
        'id': productId,
        'shopId': shopId,
        'name': name.text.trim(),
        'image': '',
        'unit': unit.text.trim(),
        'price': int.parse(price.text.trim()),
        'description': description.text,
        'published': true,
        'createdAt': DateTime.now(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateProduct({String id, String shopId, File imageFile}) async {
    if (name.text == null) return false;
    if (unit.text == null) return false;
    if (price.text == null) return false;
    String imagePath = '';
    try {
      if (imageFile != null) {
        imagePath = '$shopId/$id';
        storageRef.child(imagePath).put(imageFile);
      }
      _shopProductService.updateProduct({
        'id': id,
        'shopId': shopId,
        'name': name.text.trim(),
        'image': imagePath,
        'unit': unit.text.trim(),
        'price': int.parse(price.text.trim()),
        'description': description.text,
        'published': true,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteProduct({String id, String shopId}) async {
    String imagePath = '$shopId/$id';
    storageRef.child(imagePath).delete();
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
    unit.text = '';
    price.text = '';
    description.text = '';
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
