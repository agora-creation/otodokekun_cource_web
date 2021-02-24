import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/services/user_notice.dart';

class UserNoticeProvider with ChangeNotifier {
  UserNoticeService _userNoticeService = UserNoticeService();

  Future<bool> createNotice(
      {List<UserModel> selecteds, String title, String message}) async {
    try {
      for (UserModel user in selecteds) {
        String noticeId = _userNoticeService.getNewNoticeId(userId: user.id);
        _userNoticeService.createNotice({
          'id': noticeId,
          'userId': user.id,
          'title': title,
          'message': message,
          'read': true,
          'createdAt': DateTime.now(),
        });
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
