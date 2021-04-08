import 'dart:html';

import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/services/shop_order.dart';
import 'package:otodokekun_cource_web/services/shop_product_regular.dart';

class ShopPlanProvider with ChangeNotifier {
  ShopOrderService _shopOrderService = ShopOrderService();
  ShopProductRegularService _shopPlanService = ShopProductRegularService();

  TextEditingController name = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  File imageFile;
  DateTime deliveryAt;
  bool published;

  Future<bool> create({String shopId, List<UserModel> users}) async {
    if (name.text == null) return false;
    if (price.text == null) return false;
    if (deliveryAt == null) return false;
    String id = _shopPlanService.newId(shopId: shopId);
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
      }
      _shopPlanService.create({
        'id': id,
        'shopId': shopId,
        'name': name.text.trim(),
        'image': imageUrl,
        'unit': unit.text.trim(),
        'price': int.parse(price.text.trim()),
        'description': description.text,
        'deliveryAt': deliveryAt,
        'published': true,
        'createdAt': DateTime.now(),
      });
      for (UserModel _user in users) {
        String orderId = _shopOrderService.newId(shopId: shopId);
        List<Map> products = [];
        products.add({
          'id': id,
          'name': name.text.trim(),
          'image': imageUrl,
          'unit': unit.text.trim(),
          'price': int.parse(price.text.trim()),
          'quantity': 1,
          'totalPrice': int.parse(price.text.trim()),
        });
        _shopOrderService.create({
          'id': orderId,
          'shopId': shopId,
          'userId': _user.id,
          'name': _user.name,
          'zip': _user.zip,
          'address': _user.address,
          'tel': _user.tel,
          'products': products,
          'deliveryAt': deliveryAt,
          'remarks': '',
          'totalPrice': int.parse(price.text.trim()),
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

  Future<bool> update({String id, String shopId}) async {
    if (name.text == null) return false;
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
        _shopPlanService.update({
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
        _shopPlanService.update({
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

  Future<bool> delete({String id, String shopId}) async {
    // if (image != '') {
    //   String imagePath = '$shopId/$id';
    //   firebase.StorageReference ref = firebase
    //       .storage()
    //       .refFromURL('gs://otodokekun-cource.appspot.com/')
    //       .child(imagePath);
    //   await ref.delete();
    // }
    try {
      _shopPlanService.delete({
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
}
