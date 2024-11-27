class Product {
  final String id;
  final String name;
  final String description;
  final int price;
  final String category;
  final int sold;
  final String image;
  final List<ProductSize> productSize;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.sold,
    required this.image,
    required this.productSize,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var list = json['product_size'] as List;
    List<ProductSize> sizeList =
        list.map((i) => ProductSize.fromJson(i)).toList();

    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      category: json['category'],
      sold: json['sold'],
      image: json['image'],
      productSize: sizeList,
    );
  }
}

class ProductSize {
  final String id;
  final String size;
  final String description;
  final int stock;

  ProductSize({
    required this.id,
    required this.size,
    required this.description,
    required this.stock,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      id: json['id'],
      size: json['size'],
      description: json['description'],
      stock: json['stock'],
    );
  }
}
