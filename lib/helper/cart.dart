import 'dart:convert';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/model/cart_model.dart';
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

  final cartKey = 'cart_$userId';
  final cartData = prefs.getString(cartKey);
  List<Map<String, dynamic>> cart = cartData != null
      ? List<Map<String, dynamic>>.from(jsonDecode(cartData))
      : [];

  bool productExists = false;
  for (var item in cart) {
    if (item['id'] == product.id && item['size'] == selectedSize) {
      item['quantity'] += 1;
      productExists = true;
      break;
    }
  }

  if (!productExists) {
    cart.add({
      'id': product.id,
      'name': product.name,
      'size': selectedSize,
      'price': product.price,
      'quantity': 1,
      'image': product.image,
    });
  }

  // Simpan keranjang setelah ditambahkan item
  await prefs.setString(cartKey, jsonEncode(cart));

  // Log untuk memverifikasi apakah data keranjang berhasil disimpan
  print('Cart data saved: ${jsonEncode(cart)}');

  CustomDialog.showSuccess(
    title: 'Berhasil',
    message: '${product.name} ditambahkan ke keranjang.',
    onConfirm: () {
      Get.back();
    },
  );
}


Future<List<CartItem>> getCartItems() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('user_id');
  if (userId == null) {
    return [];
  }

  final cartKey = 'cart_$userId';
  final cartData = prefs.getString(cartKey);

  if (cartData == null || cartData.isEmpty) {
    print('Cart data is empty for user: $userId');
    return [];
  }

  try {
    // Explicitly parse the JSON string
    final List<dynamic> cartList = jsonDecode(cartData);
    print('Cart data: $cartList');
    return cartList
        .map((item) => CartItem(
              id: item['id'],
              name: item['name'],
              size: item['size'],
              price: (item['price'] as num).toDouble(),
              quantity: item['quantity'],
              image: item['image'] ?? '',
            ))
        .toList();
  } catch (e) {
    print("Error decoding cart data: $e");
    return [];
  }
}


