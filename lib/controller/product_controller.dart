import 'package:get/get.dart';
import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/product_model.dart';
import 'package:skripsi_app/service/service.dart';

class ProductController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var productList = <Product>[].obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var productDetail = Rxn<Product>();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts({String? search, int? page}) async {
    try {
      if (page == null) {
        isLoading.value = true;
        productList.clear();
        currentPage.value = 1;
      } else {
        isLoadingMore.value = true;
      }

      final response =
          await _apiService.getProducts(search: search, page: page ?? 1);

      if (response.status) {
        productList.addAll(response.data);
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

  Future<void> fetchProductDetail(String productId) async {
    try {
      isLoading.value = true;
      final response = await _apiService.getProductDetail(productId);

      if (response.status) {
        productDetail.value = response.data;
        print('Product data: ${response.data}');
      } else {
        CustomDialog.showError(
          title: 'Gagal',
          message: response.message,
          onConfirm: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      CustomDialog.showError(
        title: 'Gagal',
        message: e.toString(),
        onConfirm: () {
          Get.back();
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loadMoreProducts() {
    if (currentPage.value < lastPage.value && !isLoadingMore.value) {
      fetchProducts(page: currentPage.value + 1);
    }
  }
}
