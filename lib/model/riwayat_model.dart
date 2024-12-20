import 'package:get/get.dart';

class RiwayatModel {
  final String id;
  final String noTransaction;
  final String noReceipt;
  final RxString status;
  final int originalPrice;
  final int totalPrice;
  final int totalPoint;
  final bool usePoint;
  final int pointUsed;
  final int voucherDiscount;
  final int discountAmount;
  final String courierName;
  final int shippingCost;
  final String createdAt;
  final List<RiwayatItems> items;

  RiwayatModel({
    required this.id,
    required this.noTransaction,
    required this.noReceipt,
    required String status,
    required this.originalPrice,
    required this.totalPrice,
    required this.totalPoint,
    required this.usePoint,
    required this.pointUsed,
    required this.voucherDiscount,
    required this.discountAmount,
    required this.courierName,
    required this.shippingCost,
    required this.createdAt,
    required this.items,
  }) : status = status.obs;

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    return RiwayatModel(
      id: json['id'],
      noTransaction: json['no_transaction'],
      noReceipt: json['no_receipt'],
      status: json['status'],
      originalPrice: json['original_price'],
      totalPrice: json['total_price'],
      totalPoint: json['total_point'],
      usePoint: json['use_point'],
      pointUsed: json['point_used'],
      voucherDiscount: json['voucher_discount'],
      discountAmount: json['discount_amount'],
      courierName: json['courier_name'],
      shippingCost: json['shipping_cost'],
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


class RiwayatStatus {
  final String id;
  final String status;

  RiwayatStatus({
    required this.id,
    required this.status,
  });

  factory RiwayatStatus.fromJson(Map<String, dynamic> json) {
    return RiwayatStatus(
      id: json['id'],
      status: json['status'],
    );
  }
}