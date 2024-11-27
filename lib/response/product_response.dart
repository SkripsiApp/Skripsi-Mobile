import 'package:skripsi_app/model/product_model.dart';

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

class Pagination {
  final int limit;
  final int currentPage;
  final int lastPage;

  Pagination({
    required this.limit,
    required this.currentPage,
    required this.lastPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      limit: json['limit'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
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
