import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/user_model.dart';
import 'package:skripsi_app/service/register_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final userProfile = Rx<UserProfile?>(null);

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      bool isTokenExpired = JwtDecoder.isExpired(token);
      if (!isTokenExpired) {
        fetchProfile();
      } else {
        await prefs.remove('token');
        await prefs.remove('token_expiry');
        userProfile.value = null;
      }
    } else {
      userProfile.value = null;
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final response = await _apiService.getProfile();

      if (response.status) {
        userProfile.value = response.data;
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
