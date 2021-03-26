import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/services/shop.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class ShopProvider with ChangeNotifier {
  FirebaseAuth _auth;
  User _fUser;
  Status _status = Status.Uninitialized;
  ShopService _shopServices = ShopService();
  ShopModel _shop;

  User get fUser => _fUser;
  Status get status => _status;
  ShopModel get shop => _shop;

  bool isLoading = false;

  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController remarks = TextEditingController();
  List<int> cancelLimitList = [3, 4, 5, 6, 7];
  int cancelLimit;

  ShopProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onStateChanged);
  }

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
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
    if (zip.text == null) return false;
    if (address.text == null) return false;
    if (tel.text == null) return false;
    if (email.text == null) return false;
    if (password.text == null) return false;
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
        _shopServices.create({
          'id': value.user.uid,
          'code': '',
          'name': name.text.trim(),
          'zip': zip.text.trim(),
          'address': address.text.trim(),
          'tel': tel.text.trim(),
          'email': email.text.trim(),
          'password': password.text.trim(),
          'remarks': '',
          'terms': '',
          'cancelLimit': 3,
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

  Future<bool> update() async {
    if (name.text == null) return false;
    if (zip.text == null) return false;
    if (address.text == null) return false;
    if (tel.text == null) return false;
    if (email.text == null) return false;
    try {
      await _auth.currentUser.updateEmail(email.text.trim()).then((value) {
        _shopServices.update({
          'id': _auth.currentUser.uid,
          'code': code.text.trim(),
          'name': name.text.trim(),
          'zip': zip.text.trim(),
          'address': address.text.trim(),
          'tel': tel.text.trim(),
          'email': email.text.trim(),
          'remarks': remarks.text,
          'cancelLimit': cancelLimit,
        });
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    await _auth.signOut();
    _status = Status.Unauthenticated;
    _shop = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    code.text = '';
    name.text = '';
    zip.text = '';
    address.text = '';
    tel.text = '';
    email.text = '';
    password.text = '';
    cPassword.text = '';
    remarks.text = '';
  }

  Future reloadShopModel() async {
    _shop = await _shopServices.select(shopId: _fUser.uid);
    notifyListeners();
  }

  Future _onStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _fUser = firebaseUser;
      _status = Status.Authenticated;
      _shop = await _shopServices.select(shopId: _fUser.uid);
    }
    notifyListeners();
  }
}
