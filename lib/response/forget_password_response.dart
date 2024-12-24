class SendOTPResponse {
  final String message;
  final bool status;

  SendOTPResponse({
    required this.message,
    required this.status,
  });

  factory SendOTPResponse.fromJson(Map<String, dynamic> json) {
    return SendOTPResponse(
      message: json['message'],
      status: json['status'],
    );
  }
}

class VerifyOTPResponse {
  final String message;
  final bool status;
  final String? data;

  VerifyOTPResponse({
    required this.message,
    required this.status,
    this.data,
  });

  factory VerifyOTPResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOTPResponse(
      message: json['message'],
      status: json['status'],
      data: json['data'],
    );
  }
}

class ResetPasswordResponse {
  final String message;
  final bool status;

  ResetPasswordResponse({
    required this.message,
    required this.status,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      message: json['message'],
      status: json['status'],
    );
  }
}