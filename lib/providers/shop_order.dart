import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/services/shop_order.dart';
import 'package:otodokekun_cource_web/services/user.dart';

class ShopOrderProvider with ChangeNotifier {
  ShopOrderService _shopOrderService = ShopOrderService();
  UserService _userService = UserService();

  DateTime openedAt = DateTime(DateTime.now().year - 1);
  DateTime closedAt = DateTime(DateTime.now().year + 1);
  bool invoiceDisabled = true;
  DateTime deliveryAt = DateTime.now();
  bool deliveryAtDisabled = true;
  String userName = '';
  String staff = '';
  bool shipping = false;

  void changeInvoice({DateTime openedAt, DateTime closedAt, bool disabled}) {
    this.openedAt = openedAt;
    this.closedAt = closedAt;
    this.invoiceDisabled = disabled;
    notifyListeners();
  }

  void changeDeliveryAt({DateTime deliveryAt, bool disabled}) {
    this.deliveryAt = deliveryAt;
    this.deliveryAtDisabled = disabled;
    if (!disabled) {
      this.openedAt = DateTime(DateTime.now().year - 1);
      this.closedAt = DateTime(DateTime.now().year + 1);
      this.invoiceDisabled = true;
    }
    notifyListeners();
  }

  void changeUserName({String userName}) {
    this.userName = userName;
    notifyListeners();
  }

  void changeStaff({String staff}) {
    this.staff = staff;
    notifyListeners();
  }

  void changeShipping({bool shipping}) {
    this.shipping = shipping;
    notifyListeners();
  }

  Future<bool> update(
      {String id, String shopId, String userId, String staff}) async {
    try {
      _shopOrderService.update({
        'id': id,
        'shopId': shopId,
        'staff': staff,
      });
      _userService.update({
        'id': userId,
        'staff': staff,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateShipping(
      {String id, String shopId, String userId, String staff}) async {
    try {
      _shopOrderService.update({
        'id': id,
        'shopId': shopId,
        'staff': staff,
        'shipping': true,
      });
      _userService.update({
        'id': userId,
        'staff': staff,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> delete({String id, String shopId}) async {
    try {
      _shopOrderService.delete({
        'id': id,
        'shopId': shopId,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
