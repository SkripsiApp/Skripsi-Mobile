import 'package:get/get.dart';
import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/riwayat_model.dart';
import 'package:skripsi_app/routes/routes_named.dart';
import 'package:skripsi_app/service/service.dart';

class RiwayatController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final riwayatList = <RiwayatModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiwayat();
  }

  void onRefresh() {
    fetchRiwayat();
  }

  Future<void> fetchRiwayat({String? search, int? page}) async {
    try {
      isLoading.value = true;

      final response = await _apiService.getRiwayat(search: search, page: page ?? 1);

      if (response.status) {
        riwayatList.assignAll(response.data);
      } else {
        CustomDialog.showError(
          title: 'Pesan Kesalahan',
          message: response.message,
          onConfirm: () {
            Get.back();
            Get.toNamed(RoutesNamed.login);
          },
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}