import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_invoice.dart';
import 'package:otodokekun_cource_web/services/shop_invoice.dart';

class ShopInvoiceProvider with ChangeNotifier {
  ShopInvoiceService _shopInvoiceService = ShopInvoiceService();

  Future<bool> create({String shopId}) async {
    String id = _shopInvoiceService.newId(shopId: shopId);
    try {
      _shopInvoiceService.create({
        'id': id,
        'shopId': shopId,
        'openedAt': DateTime.now(),
        'closedAt': DateTime.now(),
        'createdAt': DateTime.now(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> delete({String id, String shopId}) async {
    try {
      _shopInvoiceService.delete({
        'id': id,
        'shopId': shopId,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<ShopInvoiceModel>> selectList({String shopId}) async {
    List<ShopInvoiceModel> _invoices = [];
    await _shopInvoiceService.selectList(shopId: shopId).then((value) {
      _invoices = value;
    });
    return _invoices;
  }
}
