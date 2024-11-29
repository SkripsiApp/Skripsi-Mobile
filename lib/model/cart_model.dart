class CartItem {
  final String id;
  final String image;
  final String name;
  final double price;
  final String size;
  int quantity;

  CartItem({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.size,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      image: json['image'],
      name: json['productName'],
      price: json['price'],
      size: json['size'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'productName': name,
      'price': price,
      'size': size,
      'quantity': quantity,
    };
  }
}