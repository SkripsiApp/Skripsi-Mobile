import 'package:skripsi_app/model/login_model.dart';

class LoginResponse {
  final bool status;
  final String message;
  final UserData? data;

  LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      data: json['status'] ? UserData.fromJson(json['data']) : null,
    );
  }
}