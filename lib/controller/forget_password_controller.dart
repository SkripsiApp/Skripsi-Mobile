import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsi_app/response/forget_password_response.dart';
import 'package:skripsi_app/routes/routes_named.dart';
import 'package:skripsi_app/service/service.dart';

class ForgetPasswordController extends GetxController {
  final ApiService _apiService = ApiService();
  final isLoading = false.obs;
  VerifyOTPResponse? response;

  String? tokens;

  void setToken(String token) {
    tokens = token;
    _apiService.setAuthToken(token);
  }

  Future<void> sendOTP(String email) async {
    try {
      isLoading.value = true;

      final response = await _apiService.sendOTP(email);

      if (response.status) {
        Get.snackbar(
          'Berhasil',
          'Link reset password telah dikirim ke email Anda.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          'Gagal',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Verifikasi OTP
  Future<void> verifyOTP(String email, String otp) async {
    try {
      isLoading.value = true;
      response = await _apiService.verifyOTP(email, otp);

      if (response!.status) {
        Get.snackbar(
          'Berhasil',
          'OTP berhasil diverifikasi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          'Gagal',
          response!.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // New password method
  Future<void> newPassword(String password, String confirmPassword) async {
    try {
      isLoading.value = true;
      final response = await _apiService.resetPassword(password, confirmPassword);

      if (response.status) {
        Get.snackbar(
          'Berhasil',
          'Password berhasil diubah.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        Get.offAllNamed(RoutesNamed.login);
      } else {
        Get.snackbar(
          'Gagal',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

}