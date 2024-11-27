import 'package:flutter/material.dart';
import 'package:skripsi_app/controller/product_controller.dart';
import 'package:get/get.dart';
import 'package:skripsi_app/helper/capitalize.dart';
import 'package:skripsi_app/routes/routes_named.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductController _controller = Get.put(ProductController());
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: AppBar(
            title: const Text('Product'),
            centerTitle: true,
            backgroundColor: const Color(0xFF3ABEF9),
            elevation: 0,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Cari Produk',
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 14,
                ),
                prefixIcon: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    String searchQuery =
                        capitalizeWords(_searchController.text);
                    _controller.fetchProducts(search: searchQuery);
                  },
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFD9D9D9),
                    )),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onSubmitted: (value) {
                String searchQuery = capitalizeWords(value);
                _controller.fetchProducts(search: searchQuery);
              },
            ),
          ),
          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildCategoryContainer('Semua', selectedCategory == 'Semua'),
                _buildCategoryContainer('Cincin', selectedCategory == 'Cincin'),
                _buildCategoryContainer('Kalung', selectedCategory == 'Kalung'),
                _buildCategoryContainer('Gelang', selectedCategory == 'Gelang'),
                _buildCategoryContainer('Anting', selectedCategory == 'Anting'),
              ],
            ),
          ),
          // Product Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildProductData(),
            ),
          ),
          // Bottom Navigation
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 1,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Produk',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble),
                label: 'Chatbot',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard),
                label: 'Voucher',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Riwayat',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryContainer(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
        onTap: () {
          _onCategorySelected(label);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
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

  Widget _buildProductCard(
    String id,
    String title,
    String price,
    String imageUrl,
    String sold,
    String category,
  ) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RoutesNamed.productDetail, arguments: id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 8,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/img/price.png',
                      width: 20,
                      height: 20,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.monetization_on, size: 20),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 120, 211, 248),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      sold,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductData() {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: _controller.productList.length +
            (_controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _controller.productList.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final product = _controller.productList[index];
          return _buildProductCard(
            product.id,
            product.name,
            'Rp ${product.price}',
            product.image,
            '${product.sold} Terjual',
            product.category,
          );
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _controller.loadMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    if (category == 'Semua') {
      _controller.fetchProducts();
    } else {
      _controller.fetchProducts(search: category);
    }
  }
}
