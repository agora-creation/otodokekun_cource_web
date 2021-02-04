import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_notice.dart';
import 'package:otodokekun_cource_web/services/shop_notice.dart';

class ShopNoticeProvider with ChangeNotifier {
  ShopNoticeService _shopNoticeService = ShopNoticeService();
  bool isLoading = false;

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
        'message': message.text,
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
        'message': message.text,
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

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getNotices({String shopId}) async {
    List<Map<String, dynamic>> _source = [];
    await _shopNoticeService.getNotices(shopId: shopId).then((value) {
      for (ShopNoticeModel _notice in value) {
        _source.add(_notice.toMap());
      }
    });
    return _source;
  }
}
