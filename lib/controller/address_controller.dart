import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/address_model.dart';
import 'package:skripsi_app/service/service.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;

  Future<void> addAddress(AddressModel data) async {
    try {
      isLoading.value = true;

      final response = await _apiService.addAddress(data);

      if (response.status) {
        CustomDialog.showSuccess(
          title: 'Berhasil',
          message: response.message,
          onConfirm: () {
            Get.back();
          },
        );
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