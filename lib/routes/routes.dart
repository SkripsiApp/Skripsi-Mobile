import 'package:skripsi_app/routes/routes_named.dart';
import 'package:skripsi_app/ui/cart/cart_screen.dart';
import 'package:skripsi_app/ui/checkout/checkout_screen.dart';
import 'package:skripsi_app/ui/home/home_screen.dart';
import 'package:skripsi_app/ui/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:skripsi_app/ui/product/detail_products.dart';
import 'package:skripsi_app/ui/product/product_screen.dart';
import 'package:skripsi_app/ui/register/register_screen.dart';

class AppRoutes {
  static final appRoutes = [
    GetPage(name: RoutesNamed.login, page: () => const LoginScreen()),
    GetPage(name: RoutesNamed.register, page: () => const RegisterScreen()),
    GetPage(name: RoutesNamed.home, page: () => const HomePage()),
    GetPage(name: RoutesNamed.product, page: () => const ProductScreen()),
    GetPage(name: RoutesNamed.productDetail, page: () => const DetailProductScreen(),),
    GetPage(name: RoutesNamed.cart, page: () => const CartScreen()),
    GetPage(name: RoutesNamed.checkout, page: () => const CheckoutScreen()),
  ];
}
