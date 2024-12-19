import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_app/controller/riwayat_controller.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final RiwayatController _controller = Get.put(RiwayatController());
  final ScrollController _scrollController = ScrollController();
  String selectedFilter = 'Semua';
  int currentPage = 1;

  final List<String> filters = [
    'Semua',
    'Belum Dibayar',
    'Dibayar',
    'Dibatalkan',
    'Dikirim',
    'Selesai'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedFilter == 'Semua') {
        _controller.fetchRiwayat();
      } else {
        _controller.fetchRiwayat(search: selectedFilter);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() {
    currentPage++;
    _controller.fetchRiwayat(
        search: selectedFilter == 'Semua' ? null : selectedFilter,
        page: currentPage);
  }

  Widget _buildCategoryContainer(String label) {
    bool isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
        onTap: () => _onCategorySelected(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3ABEF9) : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedFilter = category;
      currentPage = 1;
    });
    _controller.riwayatList.clear(); // Clear the existing list
    _controller.fetchRiwayat(
      search: category == 'Semua' ? null : category,
      page: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3ABEF9),
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Filter tabs
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: filters
                    .map((filter) => _buildCategoryContainer(filter))
                    .toList(),
              ),
            ),
          ),

          // Order list
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value &&
                  _controller.riwayatList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else if (_controller.riwayatList.isEmpty) {
                return const Center(child: Text('Data pembelian tidak ada'));
              } else {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _controller.riwayatList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _controller.riwayatList.length) {
                        return _controller.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink();
                      }
                      final riwayat = _controller.riwayatList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: OrderCard(
                          orderNumber: riwayat.noReceipt,
                          items: riwayat.items
                              .map((item) => OrderItem(
                                    image: item.image,
                                    name: item.productName,
                                    quantity: item.quantity,
                                    price: item.totalPrice,
                                    size: item.size,
                                  ))
                              .toList(),
                          status: riwayat.status,
                          date: riwayat.createdAt,
                          totalPrice: riwayat.totalPrice,
                        ),
                      );
                    },
                  );
              }
            }),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final List<OrderItem> items;
  final String status;
  final String date;
  final int totalPrice;

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.items,
    required this.status,
    required this.date,
    required this.totalPrice,
  });

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'belum dibayar':
        return Colors.orange;
      case 'dibayar':
        return Colors.blue;
      case 'dibatalkan':
        return Colors.red;
      case 'dikirim':
        return Colors.yellow;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order number
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'No Resi: $orderNumber',
                style: TextStyle(color: Colors.blue[700]),
              ),
            ),
            const SizedBox(height: 16),

            // Items
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                                'Jumlah ${item.quantity} | Size: ${item.size}'),
                          ],
                        ),
                      ),
                      Text(
                        'Rp${item.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),

            // Total and date
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Rp$totalPrice',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('dd MMMM yyyy').format(DateTime.parse(date)),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: getStatusColor(),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItem {
  final String image;
  final String name;
  final int quantity;
  final int price;
  final String size;

  const OrderItem({
    required this.image,
    required this.name,
    required this.quantity,
    required this.price,
    required this.size,
  });
}
