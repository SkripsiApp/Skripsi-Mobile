import 'package:flutter/material.dart';
import 'package:skripsi_app/helper/navigation.dart';
import 'package:skripsi_app/ui/chatbot/chatbot_screen.dart';
import 'package:skripsi_app/ui/home/home_screen.dart';
import 'package:skripsi_app/ui/product/product_screen.dart';
import 'package:skripsi_app/ui/riwayat/riwayat_screen.dart';
import 'package:skripsi_app/ui/voucher/voucher_screen.dart';

class HomeState extends StatefulWidget {
  const HomeState({super.key});

  @override
  State<HomeState> createState() => _HomePageState();
}

class _HomePageState extends State<HomeState> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProductScreen(),
    const ChatbotScreen(),
    const VoucherScreen(),
    const RiwayatScreen(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
