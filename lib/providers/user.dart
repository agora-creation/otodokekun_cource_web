import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/services/user.dart';

class UserProvider with ChangeNotifier {
  UserService _userServices = UserService();

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

  Future<List<UserModel>> getUsers({String shopId}) async {
    List<UserModel> _users = [];
    await _userServices.getUsers(shopId: shopId).then((value) {
      _users = value;
    });
    return _users;
  }
}
