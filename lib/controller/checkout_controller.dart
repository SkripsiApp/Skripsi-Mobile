import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/checkout_model.dart';
import 'package:skripsi_app/response/checkout_response.dart';
import 'package:skripsi_app/service/service.dart';
import 'package:skripsi_app/ui/payment/payment_webview.dart';

class CheckoutController extends GetxController {
  final ApiService _apiService = ApiService();
  final isLoading = false.obs;

  Future<CheckoutResponse> checkout(CheckoutRequest request) async {
    try {
      isLoading.value = true;
      final response = await _apiService.checkout(request);

      if (response.status) {
        _clearCart();
        Get.snackbar(
          'Pembayaran Berhasil',
          'Link pembayaran juga telah dikirim ke email Anda, Anda dapat melakukan pembayaran dari email tersebut.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        
        Get.off(() => PaymentWebView(url: response.data!.paymentUrl));
      } else {
        CustomDialog.showError(
          title: 'Gagal',
          message: response.message,
          onConfirm: () {
            Get.back();
          },
        );
      }
      return response;
    } catch (e) {
      CustomDialog.showError(
        title: 'Gagal',
        message: 'Terjadi kesalahan. Silakan coba lagi.',
        onConfirm: () {
          Get.back();
        },
      );
      return CheckoutResponse(status: false, message: 'Terjadi kesalahan pada server');
    }
    finally {
      isLoading.value = false;
    }
  }
}

Future<void> _clearCart() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('user_id');
  if (userId != null) {
    prefs.remove('cart_$userId');
  }
}
