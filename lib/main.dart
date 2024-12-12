import 'package:flutter/material.dart';
import 'package:skripsi_app/routes/routes.dart';
import 'package:skripsi_app/ui/address/address_list.dart';
import 'package:skripsi_app/ui/address/address_screen.dart';
import 'package:skripsi_app/ui/home/home_state.dart';
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
      home: const AddressList(),
      getPages: AppRoutes.appRoutes,
    );
  }
}
