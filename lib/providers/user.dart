import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/services/user.dart';

class UserProvider with ChangeNotifier {
  UserServices _userServices = UserServices();

  TextEditingController name = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<bool> createUser({ShopModel shop}) async {
    if (name.text == null) return false;
    if (zip.text == null) return false;
    if (address.text == null) return false;
    if (tel.text == null) return false;
    if (email.text == null) return false;
    if (password.text == null) return false;
    await FirebaseAuth.instance.signOut();
    Future.delayed(Duration.zero);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      )
          .then((value) async {
        _userServices.createUser({
          'id': value.user.uid,
          'shopId': shop.id,
          'name': name.text.trim(),
          'zip': zip.text.trim(),
          'address': address.text.trim(),
          'tel': tel.text.trim(),
          'email': email.text.trim(),
          'password': password.text.trim(),
          'createdAt': DateTime.now(),
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: shop.email,
          password: shop.password,
        );
      });
      return true;
    } catch (e) {
      print(e.toString());
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: shop.email,
        password: shop.password,
      );
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

  Future<List<Map<String, dynamic>>> getUsersList({String shopId}) async {
    List<Map<String, dynamic>> users = [];
    users = await _userServices.getUsersList(shopId: shopId);
    return users;
  }
}
