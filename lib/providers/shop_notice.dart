import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/services/shop_notice.dart';

class ShopNoticeProvider with ChangeNotifier {
  ShopNoticeService _shopNoticeService = ShopNoticeService();

  TextEditingController title = TextEditingController();
  TextEditingController message = TextEditingController();

  Future<bool> create({String shopId}) async {
    if (title.text == null) return false;
    if (message.text == null) return false;
    String id = _shopNoticeService.newId(shopId: shopId);
    try {
      _shopNoticeService.create({
        'id': id,
        'shopId': shopId,
        'title': title.text.trim(),
        'message': message.text,
        'createdAt': DateTime.now(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> update({String id, String shopId}) async {
    if (title.text == null) return false;
    if (message.text == null) return false;
    try {
      _shopNoticeService.update({
        'id': id,
        'shopId': shopId,
        'title': title.text.trim(),
        'message': message.text,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> delete({String id, String shopId}) async {
    try {
      _shopNoticeService.delete({
        'id': id,
        'shopId': shopId,
      });
      return true;
    } catch (e) {
      notifyListeners();
      return false;
    }
  }

  void clearController() {
    title.text = '';
    message.text = '';
  }
}
