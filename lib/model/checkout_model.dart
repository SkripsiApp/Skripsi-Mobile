class CheckoutRequest {
  final String? voucherId;
  final String addressId;
  final bool usePoint;
  final int? pointUsed;
  final String courierName;
  final int shippingCost;
  final List<TransactionDetail> transactionDetail;

  CheckoutRequest({
    this.voucherId,
    required this.addressId,
    required this.usePoint,
    this.pointUsed,
    required this.courierName,
    required this.shippingCost,
    required this.transactionDetail,
  });

  Map<String, dynamic> toJson() {
    return {
      'voucher_id': voucherId,
      'address_id': addressId,
      'use_point': usePoint,
      'point_used': pointUsed,
      'courier_name': courierName,
      'shipping_cost': shippingCost,
      'transaction_detail': transactionDetail.map((e) => e.toJson()).toList(),
    };
  }

  factory CheckoutRequest.fromJson(Map<String, dynamic> json) {
    var list = json['transaction_detail'] as List;
    List<TransactionDetail> detailList =
        list.map((i) => TransactionDetail.fromJson(i)).toList();

    return CheckoutRequest(
      voucherId: json['voucher_id'],
      addressId: json['address_id'],
      usePoint: json['use_point'],
      pointUsed: json['point_used'],
      courierName: json['courier_name'],
      shippingCost: json['shipping_cost'],
      transactionDetail: detailList,
    );
  }
}

class TransactionDetail {
  final String productId;
  final int quantity;
  final String size;

  TransactionDetail({
    required this.productId,
    required this.quantity,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      productId: json['product_id'],
      quantity: json['quantity'],
      size: json['size'],
    );
  }
}

