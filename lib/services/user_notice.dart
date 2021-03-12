import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class UserNoticeService {
  String _collection = 'user';
  String _subCollection = 'notice';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String newId({String userId}) {
    String id = _firebaseFirestore
        .collection(_collection)
        .doc(userId)
        .collection(_subCollection)
        .doc()
        .id;
    return id;
  }

  void create(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['userId'])
        .collection(_subCollection)
        .doc(values['id'])
        .set(values);
  }

  Future<void> sendPushMessage(
      {String token, String title, String body}) async {
    if (token == null) return;
    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: _constructFCMPayload(token: token, title: title, body: body),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  String _constructFCMPayload({String token, String title, String body}) {
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'お届けくんのお知らせ',
        'count': '1',
      },
      'notification': {
        'title': title,
        'body': body,
      },
    });
  }
}
