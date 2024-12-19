import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/user_model.dart';
import 'package:skripsi_app/routes/routes_named.dart';
import 'package:skripsi_app/service/service.dart';
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

  void onRefresh() {
    fetchProfile();
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
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editProfile(EditProfile request) async {
    try {
      isLoading.value = true;

      final response = await _apiService.editProfile(request);

      if (response.status) {
        CustomDialog.showSuccess(
          title: 'Berhasil',
          message: response.message,
          onConfirm: () {
            Get.back();
          },
        );
        fetchProfile();
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

  // logout
  Future<void> logout() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('token_expiry');
      userProfile.value = null;
      Get.offAllNamed(RoutesNamed.login);
    } finally {
      isLoading.value = false;
    }
  }
}
