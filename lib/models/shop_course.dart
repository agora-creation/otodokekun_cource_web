import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource_web/models/days.dart';

class ShopCourseModel {
  String _id;
  String _shopId;
  String _name;
  DateTime _openedAt;
  DateTime _closedAt;
  List<DaysModel> days;
  bool _published;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  String get name => _name;
  DateTime get openedAt => _openedAt;
  DateTime get closedAt => _closedAt;
  bool get published => _published;
  DateTime get createdAt => _createdAt;

  ShopCourseModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _name = snapshot.data()['name'];
    _openedAt = snapshot.data()['openedAt'].toDate();
    _closedAt = snapshot.data()['closedAt'].toDate();
    days = _convertDays(days: snapshot.data()['days']) ?? [];
    _published = snapshot.data()['published'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }

  List<DaysModel> _convertDays({List days}) {
    List<DaysModel> convertedDays = [];
    for (Map day in days) {
      convertedDays.add(DaysModel.fromMap(day));
    }
    return convertedDays;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'shopId': shopId,
        'name': name,
        'openedAt': openedAt,
        'closedAt': closedAt,
        'days': days,
        'published': published,
        'createdAt': createdAt,
      };
}
