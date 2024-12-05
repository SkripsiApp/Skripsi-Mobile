import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsi_app/model/cart_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  String? selectedShippingMethod;
  final List<String> shippingMethods = [
    "JNE - Regular",
    "J&T - Express",
    "SiCepat - Same Day",
    "POS - Kilat Khusus"
  ];
  bool usePoints = false;
  double totalPrice = 400000;
  double shippingCost = 15000;
  double discount = 20000;
  int availablePoints = 5000;

  List<CartItem> items = [];

  @override
  void initState() {
    super.initState();
    items = Get.arguments as List<CartItem>;
    totalPrice =
        items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3ABEF9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: "Alamat Pengiriman",
              content: _buildAddressContent(),
            ),
            _buildDivider(),
            _buildSection(
              title: "Produk",
              content: Column(
                children: [
                  ...items.map((item) {
                    return Column(
                      children: [
                        _buildProductCard(item.name, 'Rp ${item.price.toStringAsFixed(0)}', item.quantity, item.image),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  _buildShippingMethod(),
                ],
              ),
            ),
            _buildDivider(),
            _buildSection(
              title: "Voucher",
              content: _buildVoucherSection(),
            ),
            _buildDivider(),
            _buildPointsToggle(),
            _buildDivider(),
            _buildSummaryCard(),
            const SizedBox(height: 32),
            _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 8,
      color: const Color(0xFFF5F5F5),
    );
  }

  Widget _buildAddressContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(
          Icons.location_on,
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "Jl. Kebahagiaan No. 123, Jakarta",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3ABEF9),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text(
            "Pilih Alamat",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
      String name, String price, int quantity, String image) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Jumlah: $quantity",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingMethod() {
    return Container(
      color: Colors.white,
      child: DropdownButtonFormField<String>(
        value: selectedShippingMethod,
        items: shippingMethods
            .map((method) => DropdownMenuItem<String>(
                value: method,
                child: Text(method,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black))))
            .toList(),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            selectedShippingMethod = value;
          });
        },
        hint: const Text("Pilih Metode Pengiriman",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Punya kode voucher? Masukkan di sini",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              print("Voucher digunakan");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3ABEF9),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text(
              "Gunakan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Gunakan Point Anda",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            value: usePoints,
            onChanged: (value) {
              setState(() {
                usePoints = value;
              });
            },
            activeColor: const Color(0xFF3ABEF9),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    double pointsUsed = usePoints ? availablePoints.toDouble() : 0.0;
    double totalDiscount = discount + pointsUsed;
    double finalTotal = totalPrice + shippingCost - totalDiscount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ringkasan Belanja",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow("Total Item", "Rp ${totalPrice.toStringAsFixed(0)}"),
          const SizedBox(height: 8),
          _buildSummaryRow(
              "Ongkos Kirim", "Rp ${shippingCost.toStringAsFixed(0)}"),
          if (usePoints) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
                "Point Digunakan", "- Rp ${pointsUsed.toStringAsFixed(0)}"),
          ],
          const SizedBox(height: 8),
          _buildSummaryRow(
              "Diskon Voucher", "- Rp ${discount.toStringAsFixed(0)}"),
          const SizedBox(height: 8),
          _buildSummaryRow(
              "Total Diskon", "- Rp ${totalDiscount.toStringAsFixed(0)}"),
          const Divider(height: 24),
          _buildSummaryRow("Total", "Rp ${finalTotal.toStringAsFixed(0)}",
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    double pointsUsed = usePoints ? availablePoints.toDouble() : 0.0;
    double totalDiscount = discount + pointsUsed;
    double finalTotal = totalPrice + shippingCost - totalDiscount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Harga',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rp ${finalTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                print("Checkout button pressed");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3ABEF9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
