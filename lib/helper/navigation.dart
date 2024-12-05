import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 0,
        items: [
          _buildNavItem('Beranda', 'assets/img/home.png', 0),
          _buildNavItem('Produk', 'assets/img/product.png', 1),
          _buildNavItem('Chatbot', 'assets/img/chatbot.png', 2),
          _buildNavItem('Voucher', 'assets/img/vouchers.png', 3),
          _buildNavItem('Riwayat', 'assets/img/history.png', 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      String label, String imagePath, int index) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        imagePath,
        width: 26,
        height: 26,
        color: currentIndex == index ? Colors.blue : Colors.grey,
      ),
      label: label,
    );
  }
}
