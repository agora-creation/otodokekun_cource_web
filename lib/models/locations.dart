class LocationsModel {
  String _id;
  String _name;

  String get id => _id;
  String get name => _name;

  LocationsModel.fromMap(Map data) {
    _id = data['id'];
    _name = data['name'];
  }

  Map toMap() => {
        'id': id,
        'name': name,
      };
}
