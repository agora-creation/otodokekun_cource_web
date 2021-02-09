import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/services/user.dart';

class UserProvider with ChangeNotifier {
  UserService _userServices = UserService();

  List<bool> blacklistList = [true, false];
  bool blacklist;

  Future<bool> updateUser({String id}) async {
    try {
      _userServices.updateUser({
        'id': id,
        'blacklist': blacklist,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
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
