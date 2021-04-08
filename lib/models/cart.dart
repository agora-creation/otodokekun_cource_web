class CartModel {
  String _id;
  String _name;
  String _image;
  String _unit;
  int _price;
  int _quantity;
  int _totalPrice;

  String get id => _id;
  String get name => _name;
  String get image => _image;
  String get unit => _unit;
  int get price => _price;
  int get quantity => _quantity;
  int get totalPrice => _totalPrice;

  CartModel.fromMap(Map data) {
    _id = data['id'];
    _name = data['name'];
    _image = data['image'];
    _unit = data['unit'];
    _price = data['price'];
    _quantity = data['quantity'];
    _totalPrice = data['totalPrice'];
  }

  Map toMap() => {
        'id': id,
        'name': name,
        'image': image,
        'unit': unit,
        'price': price,
        'quantity': quantity,
        'totalPrice': totalPrice,
      };
}
