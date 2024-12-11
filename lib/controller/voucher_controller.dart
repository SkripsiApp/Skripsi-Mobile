import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/voucher_model.dart';
import 'package:skripsi_app/service/service.dart';
import 'package:get/get.dart';

class VoucherController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var voucherList = <Voucher>[].obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVouchers();
  }

  Future<void> fetchVouchers({String? search, int? page}) async {
    try {
      if (page == null) {
        isLoading.value = true;
        voucherList.clear();
        currentPage.value = 1;
      } else {
        isLoadingMore.value = true;
      }

      final response =
          await _apiService.getVouchers(search: search, page: page ?? 1);

      if (response.status) {
        voucherList.addAll(response.data);
        currentPage.value = response.pagination.currentPage;
        lastPage.value = response.pagination.lastPage;
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
      isLoadingMore.value = false;
    }
  }
}