import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class UserNoticeService {
  String _collection = 'user';
  String _subCollection = 'notice';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void create(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['userId'])
        .collection(_subCollection)
        .doc(values['id'])
        .set(values);
  }

  void sendNotification({String token, String title, String body}) {
    try {
      http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAA2rocNbY:APA91bGLuIaMcZODtI7NQ7oRjqqbO0qv4aCD7O1yuPwwTaB8kePJpPw71-pEep1J881_RBVLXinWPzdSlLQsamA8nmUp-QSDW-IlIksGButTPsCARVxHxQfbAvhK-InPNC8WImR3VJU1',
        },
        body: jsonEncode({
          'to': token,
          'priority': 'high',
          'notification': {
            'title': title,
            'body': body,
          },
        }),
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
