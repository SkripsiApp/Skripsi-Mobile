class RiwayatModel {
  final String noReceipt;
  final String status;
  final int totalPrice;
  final String createdAt;
  final List<RiwayatItems> items;

  RiwayatModel({
    required this.noReceipt,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.items,
  });

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    return RiwayatModel(
      noReceipt: json['no_receipt'],
      status: json['status'],
      totalPrice: json['total_price'],
      createdAt: json['created_at'],
      items: (json['transaction_details'] as List<dynamic>?)
              ?.map((item) => RiwayatItems.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class RiwayatItems {
  final String productName;
  final String image;
  final int quantity;
  final String size;
  final int totalPrice;

  RiwayatItems({
    required this.productName,
    required this.image,
    required this.quantity,
    required this.size,
    required this.totalPrice,
  });

  factory RiwayatItems.fromJson(Map<String, dynamic> json) {
    return RiwayatItems(
      productName: json['product_name'],
      image: json['image'],
      quantity: json['quantity'],
      size: json['size'],
      totalPrice: json['total_price'],
    );
  }
}
