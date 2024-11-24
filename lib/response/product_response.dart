import 'package:skripsi_app/model/product_model.dart';

class ProductResponse {
  final bool status;
  final String message;
  final List<Product> data;

  ProductResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Product> productList = list.map((i) => Product.fromJson(i)).toList();

    return ProductResponse(
      status: json['status'],
      message: json['message'],
      data: productList,
    );
  }
}
