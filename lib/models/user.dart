import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource_web/models/locations.dart';

class UserModel {
  String _id;
  String _shopId;
  String _name;
  String _zip;
  String _address;
  String _tel;
  String _email;
  String _password;
  List<LocationsModel> locations;
  bool _blacklist;
  String _staff;
  bool _fixed;
  String _token;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  String get name => _name;
  String get zip => _zip;
  String get address => _address;
  String get tel => _tel;
  String get email => _email;
  String get password => _password;
  bool get blacklist => _blacklist;
  String get staff => _staff;
  bool get fixed => _fixed;
  String get token => _token;
  DateTime get createdAt => _createdAt;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _name = snapshot.data()['name'];
    _zip = snapshot.data()['zip'];
    _address = snapshot.data()['address'];
    _tel = snapshot.data()['tel'];
    _email = snapshot.data()['email'];
    _password = snapshot.data()['password'];
    locations =
        _convertLocations(locations: snapshot.data()['locations']) ?? [];
    _blacklist = snapshot.data()['blacklist'];
    _staff = snapshot.data()['staff'];
    _fixed = snapshot.data()['fixed'];
    _token = snapshot.data()['token'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }

  List<LocationsModel> _convertLocations({List locations}) {
    List<LocationsModel> convertedLocations = [];
    for (Map data in locations) {
      convertedLocations.add(LocationsModel.fromMap(data));
    }
    return convertedLocations;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'shopId': shopId,
        'name': name,
        'zip': zip,
        'address': address,
        'tel': tel,
        'email': email,
        'password': password,
        'locations': locations,
        'blacklist': blacklist,
        'blacklistText': blacklist ? '設定済み' : '設定なし',
        'staff': staff,
        'fixed': fixed,
        'token': token,
        'createdAt': createdAt,
      };
}
