import 'package:get/get.dart';
import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/riwayat_model.dart';
import 'package:skripsi_app/routes/routes_named.dart';
import 'package:skripsi_app/service/service.dart';

class RiwayatController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  var isLoadingMore = false.obs;
  final riwayatList = <RiwayatModel>[].obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;

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
      if (page == null) {
        isLoading.value = true;
        riwayatList.clear();
        currentPage.value = 1;
      } else {
        isLoadingMore.value = true;
      }

      final response = await _apiService.getRiwayat(search: search, page: page ?? 1);

      if (response.status) {
        riwayatList.assignAll(response.data);
        currentPage.value = response.pagination.currentPage;
        lastPage.value = response.pagination.lastPage;
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
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreRiwayat() async {
    if (currentPage.value < lastPage.value && !isLoadingMore.value) {
      await fetchRiwayat(page: currentPage.value + 1);
    }
  }

  void resetPagination() {
    currentPage.value = 1;
    lastPage.value = 1;
    riwayatList.clear();
  }

  // Update Riwayat
  Future<void> updateRiwayat(RiwayatStatus data) async {
    try {
      isLoading.value = true;

      final response = await _apiService.updateRiwayat(data.id, data.status);

      if (response.status) {
        CustomDialog.showSuccess(
          title: 'Berhasil',
          message: response.message,
          onConfirm: () {
            Get.back();
          },
        );
        fetchRiwayat();
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