import 'package:skripsi_app/routes/routes_named.dart';
import 'package:skripsi_app/ui/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:skripsi_app/ui/register/register_screen.dart';

class AppRoutes {
  static final appRoutes = [
    GetPage(name: RoutesNamed.login, page: () => const LoginScreen()),
    GetPage(name: RoutesNamed.register, page: () => const RegisterScreen()),
  ];
}
