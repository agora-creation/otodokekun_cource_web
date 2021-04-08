class TmpModel {
  String _id;
  String _name;
  bool _target;

  String get id => _id;
  String get name => _name;
  bool get target => _target;

  TmpModel.fromMap(Map data) {
    _id = data['id'];
    _name = data['name'];
    _target = data['target'];
  }

  Map toMap() => {
        'id': id,
        'name': name,
        'target': target,
      };
}
