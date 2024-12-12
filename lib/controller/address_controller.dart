import 'package:get/get.dart';
import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/address_model.dart';
import 'package:skripsi_app/service/service.dart';

class AddressController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  var addressList = <AddressModel>[].obs;
  var selectedAddressId = RxnString();

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
        fetchAddress(); // Refresh the address list
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

  Future<void> fetchAddress() async {
    try {
      isLoading.value = true;

      final response = await _apiService.getAddresses();

      if (response.status && response.data != null) {
        addressList.assignAll(response.data!);
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
        title: 'Error',
        message: 'Terjadi kesalahan: ${e.toString()}',
        onConfirm: () {
          Get.back();
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectAddress(String? id) {
    selectedAddressId.value = id;
  }

  bool isAddressSelected(String? id) {
    return selectedAddressId.value == id;
  }
}
