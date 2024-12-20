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
  final String noTransaction;
  final String paymentUrl;

  CheckoutData({
    required this.id,
    required this.noTransaction,
    required this.paymentUrl,
  });

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(
      id: json['id'],
      noTransaction: json['no_transaction'],
      paymentUrl: json['payment_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no_transaction': noTransaction,
      'payment_url': paymentUrl,
    };
  }
}
