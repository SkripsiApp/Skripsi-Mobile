import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_app/controller/riwayat_controller.dart';
import 'package:skripsi_app/model/riwayat_model.dart';

class DetailRiwayatScreen extends StatelessWidget {
  final RiwayatModel riwayat;
  final RiwayatController controller = Get.find<RiwayatController>();

  DetailRiwayatScreen({super.key, required this.riwayat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3ABEF9),
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Informasi Pesanan',
              content: _buildOrderInfo(),
            ),
            _buildDivider(),
            _buildSection(
              title: 'Detail Produk',
              content: Column(
                children: [
                  ...riwayat.items.map((item) => _buildProductItem(item)),
                ],
              ),
            ),
            _buildDivider(),
            _buildSection(
              title: 'Ringkasan Pembayaran',
              content: _buildPaymentSummary(),
            ),
            _buildDivider(),
            _buildSection(
              title: 'Informasi Pengiriman',
              content: _buildShippingInfo(),
            ),
            const SizedBox(height: 24),
            Obx(
              () {
                if (riwayat.status.toLowerCase() == 'dikirim') {
                  return _buildCompleteOrderButton(context);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
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
              fontSize: 18,
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

  Widget _buildOrderInfo() {
    return Column(
      children: [
        _buildInfoRow('No. Pesanan', riwayat.noTransaction),
        _buildInfoRow(
          'Tanggal Pemesanan',
          DateFormat('dd MMMM yyyy HH:mm')
              .format(DateTime.parse(riwayat.createdAt)),
        ),
        Obx(() => _buildInfoRow('Status', riwayat.status.value, isStatus: true)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          if (isStatus)
            _buildStatusChip(value)
          else
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'dibayar':
        chipColor = Colors.blue;
        break;
      case 'dibatalkan':
        chipColor = Colors.red;
        break;
      case 'dikirim':
        chipColor = Colors.yellow;
        break;
      case 'selesai':
        chipColor = Colors.green;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
    );
  }

  Widget _buildProductItem(RiwayatItems item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${item.size} | Jumlah: ${item.quantity}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp${NumberFormat('#,###').format(item.totalPrice)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Column(
      children: [
        _buildSummaryRow('Subtotal Produk',
            'Rp${NumberFormat('#,###').format(riwayat.originalPrice)}'),
        _buildSummaryRow('Biaya Pengiriman',
            'Rp${NumberFormat('#,###').format(riwayat.shippingCost)}'),
        if (riwayat.usePoint)
          _buildSummaryRow('Poin Digunakan',
              '- Rp${NumberFormat('#,###').format(riwayat.pointUsed)}'),
        if (riwayat.voucherDiscount > 0)
          _buildSummaryRow('Voucher Diskon',
              '- Rp${NumberFormat('#,###').format(riwayat.voucherDiscount)}'),
        if (riwayat.discountAmount > 0)
          _buildSummaryRow('Total Diskon',
              '- Rp${NumberFormat('#,###').format(riwayat.discountAmount)}'),
        const Divider(height: 16),
        _buildSummaryRow(
            'Total', 'Rp${NumberFormat('#,###').format(riwayat.totalPrice)}',
            isBold: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.black : Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingInfo() {
    return Column(
      children: [
        _buildInfoRow('Kurir', riwayat.courierName),
        if (riwayat.noReceipt.isNotEmpty)
          _buildInfoRow('No. Resi', riwayat.noReceipt),
      ],
    );
  }

  Widget _buildCompleteOrderButton(BuildContext context) {
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
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _confirmOrderCompletion(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3ABEF9),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Pesanan Selesai',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _confirmOrderCompletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin pesanan ini telah selesai?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ya'),
              onPressed: () {
                Navigator.of(context).pop();
                _completeOrder();
              },
            ),
          ],
        );
      },
    );
  }

  void _completeOrder() async {
    final riwayatStatus = RiwayatStatus(id: riwayat.id, status: "Selesai");
    await controller.updateRiwayat(riwayatStatus);
    riwayat.status.value = "Selesai";
  }
}
