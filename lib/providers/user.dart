import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/services/user.dart';

class UserProvider with ChangeNotifier {
  UserServices _userServices = UserServices();
  bool isLoading = false;

  TextEditingController name = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<bool> updateUser({String id, ShopModel shop}) async {
    if (name.text == null) return false;
    if (zip.text == null) return false;
    if (address.text == null) return false;
    if (tel.text == null) return false;
    try {
      _userServices.updateUser({
        'id': id,
        'shopId': shop.id,
        'name': name.text.trim(),
        'zip': zip.text.trim(),
        'address': address.text.trim(),
        'tel': tel.text.trim(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void clearController() {
    name.text = '';
    zip.text = '';
    address.text = '';
    tel.text = '';
    email.text = '';
    password.text = '';
  }

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getUsers({String shopId}) async {
    List<Map<String, dynamic>> _source = [];
    await _userServices.getUsers(shopId: shopId).then((value) {
      for (UserModel _user in value) {
        _source.add(_user.toMap());
      }
    });
    return _source;
  }
}
