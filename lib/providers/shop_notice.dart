import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/services/shop_notice.dart';

class ShopNoticeProvider with ChangeNotifier {
  ShopNoticeService _shopNoticeService = ShopNoticeService();

  TextEditingController title = TextEditingController();
  TextEditingController message = TextEditingController();
}
