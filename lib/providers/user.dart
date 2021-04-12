import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/services/user.dart';

class UserProvider with ChangeNotifier {
  UserService _userServices = UserService();

  bool blacklist;
  String staff;

  Future<bool> update({String id}) async {
    try {
      _userServices.update({
        'id': id,
        'blacklist': blacklist,
        'staff': staff,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<UserModel>> selectList({String shopId}) async {
    List<UserModel> _users = [];
    await _userServices.selectList(shopId: shopId).then((value) {
      _users = value;
    });
    return _users;
  }

  Future<List<UserModel>> selectListNotice(
      {String noticeId, String shopId}) async {
    List<UserModel> _users = [];
    await _userServices
        .selectListNotice(noticeId: noticeId, shopId: shopId)
        .then((value) {
      _users = value;
    });
    return _users;
  }

  Future<List<UserModel>> selectListRegular({String shopId}) async {
    List<UserModel> _users = [];
    await _userServices.selectListRegular(shopId: shopId).then((value) {
      _users = value;
    });
    return _users;
  }
}
