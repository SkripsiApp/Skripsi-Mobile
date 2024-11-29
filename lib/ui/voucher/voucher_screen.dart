import 'package:flutter/material.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Voucher',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Image.asset(
                  'assets/img/voucher2.png',
                  width: 70,
                  height: 70,
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3ABEF9),
                      ),
                    ),
                    Text(
                      'Jumlah Voucher',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
              children: [
                _buildVoucherCard(
                  'Promo Diskon 30%',
                  'Diskon 30% untuk semua aksesoris titanium. Dapatkan sekarang!',
                  'GELANGKU2024',
                ),
                const SizedBox(height: 16),
                _buildVoucherCard(
                  'Promo Diskon 10%',
                  'Diskon 10% untuk semua aksesoris titanium. Dapatkan sekarang!',
                  'PROMO1212',
                ),
                const SizedBox(height: 16),
                _buildVoucherCard(
                  'Promo Diskon 20%',
                  'Diskon 20% untuk semua aksesoris titanium. Dapatkan sekarang!',
                  'DISKON20',
                ),
                const SizedBox(height: 16),
                _buildVoucherCard(
                  'Promo Diskon 20%',
                  'Diskon 20% untuk semua aksesoris titanium. Dapatkan sekarang!',
                  'DISKON20',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.discount),
            label: 'Voucher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildVoucherCard(String title, String description, String promoCode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
             Positioned(
              top: -30,
              right: -40,
                child: Image.asset(
                  'assets/img/diamond.png',
                  width: 200,
                  height: 200,
                ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/img/voucher.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    promoCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}