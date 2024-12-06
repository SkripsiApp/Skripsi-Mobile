import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi_app/ui/chatbot/chatbot_screen.dart';
import 'package:skripsi_app/ui/home/home_screen.dart';
import 'package:skripsi_app/ui/product/product_screen.dart';
import 'package:skripsi_app/ui/riwayat/riwayat_screen.dart';
import 'package:skripsi_app/ui/voucher/voucher_screen.dart';
import 'package:skripsi_app/helper/navigation.dart';

class HomeState extends StatefulWidget {
  const HomeState({super.key});

  @override
  State<HomeState> createState() => _HomePageState();
}

class _HomePageState extends State<HomeState> {
  final HomeController _homeController = Get.put(HomeController());

  final List<Widget> _pages = [
    const HomePage(),
    const ProductScreen(),
    const ChatbotScreen(),
    const VoucherScreen(),
    const RiwayatScreen(),
  ];

  void _onNavItemTapped(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentIndex', index);
    _homeController.setCurrentIndex(index);
  }

  void _loadCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    _homeController.setCurrentIndex(prefs.getInt('currentIndex') ?? 0);
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => _pages[_homeController.currentIndex.value]),
      ),
      bottomNavigationBar: Obx(() => CustomBottomNav(
            currentIndex: _homeController.currentIndex.value,
            onTap: _onNavItemTapped,
          )),
    );
  }
}
