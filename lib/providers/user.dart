import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/services/user.dart';
import 'package:responsive_table/DatatableHeader.dart';

class UserProvider with ChangeNotifier {
  UserServices _userServices = UserServices();
  List<DatatableHeader> headers = [
    DatatableHeader(
      text: 'ID',
      value: 'id',
      show: false,
      sortable: true,
      textAlign: TextAlign.left,
    ),
    DatatableHeader(
      text: '名前',
      value: 'name',
      show: true,
      sortable: true,
      textAlign: TextAlign.left,
    ),
    DatatableHeader(
      text: '電話番号',
      value: 'tel',
      show: true,
      sortable: true,
      textAlign: TextAlign.left,
    ),
    DatatableHeader(
      text: 'メールアドレス',
      value: 'email',
      show: true,
      sortable: true,
      textAlign: TextAlign.left,
    ),
    DatatableHeader(
      text: '登録日時',
      value: 'createdAt',
      show: true,
      sortable: true,
      textAlign: TextAlign.left,
    ),
  ];
  List<int> perPages = [5, 10, 15, 100];
  int total = 100;
  int currentPerPage;
  int currentPage = 1;
  bool isSearch = false;
  List<Map<String, dynamic>> source = [];
  List<Map<String, dynamic>> selecteds = [];
  String selectableKey = 'id';
  String sortColumn;
  bool sortAscending = true;
  bool isLoading = true;
  bool showSelect = true;

  TextEditingController name = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<bool> createUser({ShopModel shopModel}) async {
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
          'shopId': shopModel.id,
          'name': name.text.trim(),
          'zip': zip.text.trim(),
          'address': address.text.trim(),
          'tel': tel.text.trim(),
          'email': email.text.trim(),
          'password': password.text.trim(),
          'createdAt': DateTime.now(),
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: shopModel.email,
          password: shopModel.password,
        );
      });
      return true;
    } catch (e) {
      print(e.toString());
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

  Future<QuerySnapshot> getUsers({String shopId}) async {
    return await _userServices.getUsers(shopId: shopId);
  }

  List<Map<String, dynamic>> _generateData({int n: 100}) {
    final List source = List.filled(n, Random.secure());
    List<Map<String, dynamic>> temps = [];
    var i = source.length;
    print(i);
    for (var data in source) {
      temps.add({
        'id': i,
        'name': '弁当 $i',
        'tel': '090-6289-3491-$i',
        'email': 'info@gmail.com-$i',
        'password': 'password-$i',
        'createdAt': '2021/01/26',
      });
      i++;
    }
    return temps;
  }

  void initData() async {
    isLoading = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 3)).then((value) {
      source.addAll(_generateData(n: 1000));
      isLoading = false;
      notifyListeners();
    });
  }

  void onSort(dynamic value) {
    sortColumn = value;
    sortAscending = !sortAscending;
    if (sortAscending) {
      source.sort((a, b) => b['$sortColumn'].compareTo(a['$sortColumn']));
    } else {
      source.sort((a, b) => a['$sortColumn'].compareTo(b['$sortColumn']));
    }
    notifyListeners();
  }

  void onSelect(bool value, Map<String, dynamic> item) {
    if (value) {
      selecteds.add(item);
      notifyListeners();
    } else {
      selecteds.removeAt(selecteds.indexOf(item));
      notifyListeners();
    }
  }

  void onSelectAll(bool value) {
    if (value) {
      selecteds = source.map((e) => e).toList().cast();
      notifyListeners();
    } else {
      selecteds.clear();
      notifyListeners();
    }
  }

  void dropdownOnChanged(dynamic value) {
    currentPerPage = value;
    notifyListeners();
  }

  void backOnPressed() {
    currentPage = currentPage >= 2 ? currentPage - 1 : 1;
    notifyListeners();
  }

  void forwardOnPressed() {
    currentPage++;
    notifyListeners();
  }
}
