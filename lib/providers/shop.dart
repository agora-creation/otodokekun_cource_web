import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/services/shop.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class ShopProvider with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  ShopServices _shopServices = ShopServices();
  ShopModel _shop;

  ShopModel get shop => _shop;
  Status get status => _status;
  User get user => _user;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController staff = TextEditingController();

  ShopProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn() async {
    if (email.text == null) return false;
    if (password.text == null) return false;
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp() async {
    if (name.text == null) return false;
    if (email.text == null) return false;
    if (password.text == null) return false;
    if (cPassword.text == null) return false;
    if (password.text != cPassword.text) return false;
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      )
          .then((value) {
        _shopServices.createShop({
          'id': value.user.uid,
          'name': name.text.trim(),
          'zip': '',
          'address': '',
          'tel': '',
          'email': email.text.trim(),
          'password': password.text.trim(),
          'staff': '',
          'createdAt': DateTime.now(),
        });
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    await _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<bool> updateShop() async {
    try {
      _shopServices.updateShop({
        'id': _auth.currentUser.uid,
        'name': name.text.trim(),
        'zip': zip.text.trim(),
        'address': address.text.trim(),
        'tel': tel.text.trim(),
        'staff': staff.text.trim(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void clearController() {
    email.text = '';
    password.text = '';
    cPassword.text = '';
    name.text = '';
    zip.text = '';
    address.text = '';
    tel.text = '';
    staff.text = '';
  }

  void setController() {
    name.text = _shop.name;
    zip.text = _shop.zip;
    address.text = _shop.address;
    tel.text = _shop.tel;
    staff.text = _shop.staff;
    notifyListeners();
  }

  Future reloadShopModel() async {
    _shop = await _shopServices.getShop(shopId: user.uid);
    notifyListeners();
  }

  Future _onStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      _shop = await _shopServices.getShop(shopId: _user.uid);
    }
    notifyListeners();
  }
}
