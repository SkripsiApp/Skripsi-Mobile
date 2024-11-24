import 'package:get/get.dart';
import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/register_model.dart';
import 'package:skripsi_app/service/register_service.dart';

class RegisterController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;

  Future<void> register({
    required String username,
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;

      final request = RegisterRequest(
        username: username,
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      final response = await _apiService.register(request);

     if (response.status) {
        // Dialog jika berhasil
         CustomDialog.showSuccess(
          title: 'Berhasil',
          message: response.message,
          onConfirm: () {
            Get.back();
            Get.offAllNamed('/login');
          },
        );
      } else {
        // Dialog jika gagal
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
