import 'package:get/get.dart';
import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final response = await _apiService.login(email, password);

      if (response.status) {
        // Simpan token ke local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data!.token);
        DateTime expiryDate = JwtDecoder.getExpirationDate(response.data!.token);
        await prefs.setString('token_expiry', expiryDate.toIso8601String());
        
        Get.offAllNamed('/home');
      } else {
        CustomDialog.showError(
          title: 'Gagal',
          message: response.message,
          onConfirm: () {
            Get.back();
          },
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
