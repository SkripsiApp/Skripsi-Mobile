import 'package:skripsi_app/model/product_model.dart';
import 'package:skripsi_app/response/pagination_response.dart';

class ProductResponse {
  final bool status;
  final String message;
  final List<Product> data;
  final Pagination pagination;

  ProductResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Product> productList = list.map((i) => Product.fromJson(i)).toList();

    return ProductResponse(
      status: json['status'],
      message: json['message'],
      data: productList,
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class ProductDetailResponse {
  final bool status;
  final String message;
  final Product data;

  ProductDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      status: json['status'],
      message: json['message'],
      data: Product.fromJson(json['data']),
    );
  }
}
