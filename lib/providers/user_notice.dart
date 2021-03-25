import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/services/user_notice.dart';

class UserNoticeProvider with ChangeNotifier {
  UserNoticeService _userNoticeService = UserNoticeService();

  Future<bool> create(
      {List<UserModel> users, String id, String title, String message}) async {
    try {
      for (UserModel user in users) {
        _userNoticeService.create({
          'id': id,
          'shopId': user.shopId,
          'userId': user.id,
          'title': title,
          'message': message,
          'read': true,
          'createdAt': DateTime.now(),
        });
        _userNoticeService.sendNotification(
          token: user.token,
          title: title,
          body: message,
        );
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
