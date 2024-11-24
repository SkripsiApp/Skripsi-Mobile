import 'package:get/get.dart';
import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/product_model.dart';
import 'package:skripsi_app/service/register_service.dart';

class ProductController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final productList = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final response = await _apiService.getProducts();

      if (response.status) {
        productList.value = response.data;
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
