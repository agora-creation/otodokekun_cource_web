import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_notice.dart';
import 'package:otodokekun_cource_web/services/shop_notice.dart';

class ShopNoticeProvider with ChangeNotifier {
  ShopNoticeService _shopNoticeService = ShopNoticeService();

  TextEditingController title = TextEditingController();
  TextEditingController message = TextEditingController();

  Future<bool> createNotice({String shopId}) async {
    if (title.text == null) return false;
    if (message.text == null) return false;
    String noticeId = _shopNoticeService.getNewNoticeId(shopId: shopId);
    try {
      _shopNoticeService.createNotice({
        'id': noticeId,
        'shopId': shopId,
        'title': title.text.trim(),
        'message': message.text.trim(),
        'createdAt': DateTime.now(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateNotice({String id, String shopId}) async {
    if (title.text == null) return false;
    if (message.text == null) return false;
    try {
      _shopNoticeService.updateNotice({
        'id': id,
        'shopId': shopId,
        'title': title.text.trim(),
        'message': message.text.trim(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteNotice({String id, String shopId}) async {
    try {
      _shopNoticeService.deleteNotice({
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
    title.text = '';
    message.text = '';
  }

  Future<List<Map<String, dynamic>>> getNoticesSource({String shopId}) async {
    List<Map<String, dynamic>> source = [];
    List<ShopNoticeModel> notices = [];
    notices = await _shopNoticeService.getNotices(shopId: shopId);
    for (ShopNoticeModel notice in notices) {
      source.add(notice.toMap());
    }
    return source;
  }
}
