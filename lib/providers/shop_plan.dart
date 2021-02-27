import 'dart:html';

import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/services/shop_plan.dart';

class ShopPlanProvider with ChangeNotifier {
  ShopPlanService _shopPlanService = ShopPlanService();

  TextEditingController name = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  File imageFile;
  DateTime deliveryAt;
  bool published;

  Future<bool> create({String shopId}) async {
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
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> update({String id, String shopId}) async {
    if (name.text == null) return false;
    if (price.text == null) return false;
    if (deliveryAt == null) return false;
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
          'deliveryAt': deliveryAt,
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
          'deliveryAt': deliveryAt,
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
