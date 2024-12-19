import 'package:skripsi_app/model/user_model.dart';

class ProfileResponse {
  final bool status;
  final String message;
  final UserProfile? data;

  ProfileResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? UserProfile.fromJson(json['data']) : null,
    );
  }
}

class EditProfileResponse {
  final bool status;
  final String message;

  EditProfileResponse({
    required this.status,
    required this.message,
  });

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) {
    return EditProfileResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
