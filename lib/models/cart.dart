class CartModel {
  String _id;
  String _name;
  String _image;
  String _unit;
  int _price;
  int quantity;
  int totalPrice;

  String get id => _id;
  String get name => _name;
  String get image => _image;
  String get unit => _unit;
  int get price => _price;

  CartModel.fromMap(Map data) {
    _id = data['id'];
    _name = data['name'];
    _image = data['image'];
    _unit = data['unit'];
    _price = data['price'];
    quantity = data['quantity'];
    totalPrice = data['totalPrice'];
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
