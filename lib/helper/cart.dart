import 'dart:convert';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/product_model.dart';

void addToCart(Product product, String selectedSize) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null || JwtDecoder.isExpired(token)) {
    // Jika belum login atau token kadaluarsa
    CustomDialog.showError(
      title: 'Login Diperlukan',
      message: 'Silakan login untuk menambahkan ke keranjang.',
      onConfirm: () {
        Get.back();
        Get.toNamed('/login');
      },
    );
    return;
  }

  // Ambil ID pengguna dari profil atau token
  final userId = prefs.getString('user_id');
  if (userId == null) {
    CustomDialog.showError(
      title: 'Kesalahan',
      message: 'Tidak dapat menemukan informasi pengguna.',
      onConfirm: () {
        Get.back();
      },
    );
    return;
  }

  // Ambil data keranjang dari local storage
  final cartKey = 'cart_$userId';
  final cartData = prefs.getString(cartKey);
  List<Map<String, dynamic>> cart = cartData != null
      ? List<Map<String, dynamic>>.from(jsonDecode(cartData))
      : [];

  bool productExists = false;
  for (var item in cart) {
    if (item['productId'] == product.id && item['size'] == selectedSize) {
      item['quantity'] += 1;
      productExists = true;
      break;
    }
  }

  if (!productExists) {
    cart.add({
      'productId': product.id,
      'productName': product.name,
      'size': selectedSize,
      'price': product.price,
      'quantity': 1,
      'image': product.image,
    });
  }

  await prefs.setString(cartKey, jsonEncode(cart));

  CustomDialog.showSuccess(
    title: 'Berhasil',
    message: '${product.name} ditambahkan ke keranjang.',
    onConfirm: () {
      Get.back();
    },
  );
}
