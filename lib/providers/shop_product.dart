import 'dart:html';

import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_product.dart';
import 'package:otodokekun_cource_web/services/shop_product.dart';

class ShopProductProvider with ChangeNotifier {
  ShopProductService _shopProductService = ShopProductService();

  TextEditingController name = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  bool published;

  Future<bool> createProduct({String shopId, File imageFile}) async {
    if (name.text == null) return false;
    if (unit.text == null) return false;
    if (price.text == null) return false;
    String productId = _shopProductService.getNewProductId(shopId: shopId);
    String imagePath = '$shopId/$productId';
    String imageUrl = '';
    try {
      if (imageFile != null) {
        firebase.StorageReference ref = firebase
            .storage()
            .refFromURL('gs://otodokekun-cource.appspot.com/')
            .child(imagePath);
        await ref.put(imageFile).future.then((value) async {
          var uri = await ref.getDownloadURL();
          imageUrl = uri.toString();
        });
      }
      _shopProductService.createProduct({
        'id': productId,
        'shopId': shopId,
        'name': name.text.trim(),
        'image': imageUrl,
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
    String imagePath = '$shopId/$id';
    String imageUrl = '';
    try {
      if (imageFile != null) {
        firebase.StorageReference ref = firebase
            .storage()
            .refFromURL('gs://otodokekun-cource.appspot.com/')
            .child(imagePath);
        await ref.put(imageFile).future.then((value) async {
          var uri = await ref.getDownloadURL();
          imageUrl = uri.toString();
        });
        _shopProductService.updateProduct({
          'id': id,
          'shopId': shopId,
          'name': name.text.trim(),
          'image': imageUrl,
          'unit': unit.text.trim(),
          'price': int.parse(price.text.trim()),
          'description': description.text,
          'published': published,
        });
      } else {
        _shopProductService.updateProduct({
          'id': id,
          'shopId': shopId,
          'name': name.text.trim(),
          'unit': unit.text.trim(),
          'price': int.parse(price.text.trim()),
          'description': description.text,
          'published': published,
        });
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteProduct({String id, String shopId, String image}) async {
    // if (image != '') {
    //   String imagePath = '$shopId/$id';
    //   firebase.StorageReference ref = firebase
    //       .storage()
    //       .refFromURL('gs://otodokekun-cource.appspot.com/')
    //       .child(imagePath);
    //   await ref.delete();
    // }
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

  Future<List<ShopProductModel>> getProducts({String shopId}) async {
    List<ShopProductModel> _products = [];
    await _shopProductService.getProducts(shopId: shopId).then((value) {
      _products = value;
    });
    return _products;
  }
}
