import 'package:flutter/material.dart';
import 'package:skripsi_app/routes/routes.dart';
import 'package:skripsi_app/ui/home/home_screen.dart';
import 'package:skripsi_app/ui/login/login_screen.dart';
import 'package:skripsi_app/ui/product/detail_products.dart';
import 'package:skripsi_app/ui/product/product_screen.dart';
import 'package:skripsi_app/ui/register/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const HomePage(),
      getPages: AppRoutes.appRoutes,
    );
  }
}
