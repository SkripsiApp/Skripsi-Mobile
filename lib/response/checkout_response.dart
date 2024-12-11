class CheckoutResponse {
  final bool status;
  final String message;
  final CheckoutData? data;

  CheckoutResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? CheckoutData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}


class CheckoutData {
  final String id;
  final String userId;
  final String? voucherId;
  final String addressId;
  final int originalPrice;
  final int totalPrice;
  final int totalPoint;
  final bool usePoint;
  final int pointUsed;
  final int discountAmount;
  final String courierName;
  final int shippingCost;
  final String paymentUrl;

  CheckoutData({
    required this.id,
    required this.userId,
    this.voucherId,
    required this.addressId,
    required this.originalPrice,
    required this.totalPrice,
    required this.totalPoint,
    required this.usePoint,
    required this.pointUsed,
    required this.discountAmount,
    required this.courierName,
    required this.shippingCost,
    required this.paymentUrl,
  });

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(
      id: json['id'],
      userId: json['user_id'],
      voucherId: json['voucher_id'],
      addressId: json['address_id'],
      originalPrice: json['original_price'],
      totalPrice: json['total_price'],
      totalPoint: json['total_point'],
      usePoint: json['use_point'],
      pointUsed: json['point_used'],
      discountAmount: json['discount_amount'],
      courierName: json['courier_name'],
      shippingCost: json['shipping_cost'],
      paymentUrl: json['payment_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'voucher_id': voucherId,
      'address_id': addressId,
      'original_price': originalPrice,
      'total_price': totalPrice,
      'total_point': totalPoint,
      'use_point': usePoint,
      'point_used': pointUsed,
      'discount_amount': discountAmount,
      'courier_name': courierName,
      'shipping_cost': shippingCost,
      'payment_url': paymentUrl,
    };
  }
}