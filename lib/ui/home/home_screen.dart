import 'package:flutter/material.dart';
import 'package:skripsi_app/controller/product_controller.dart';
import 'package:get/get.dart';
import 'package:skripsi_app/controller/user_controller.dart';
import 'package:skripsi_app/helper/cart.dart';
import 'package:skripsi_app/helper/dialog.dart';
import 'package:skripsi_app/helper/navigation.dart';
import 'package:skripsi_app/routes/routes_named.dart';
import 'package:skripsi_app/ui/product/product_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController _controller = Get.put(ProductController());
  final ProfileController _profileController = Get.put(ProfileController());
  final HomeController _homeController = Get.find<HomeController>();

  final _cartItemCount = 0.obs;

  @override
  void initState() {
    super.initState();
    _loadCartItemCount();
  }

  Future<void> _loadCartItemCount() async {
    final cartItems = await getCartItems();
    _cartItemCount.value = cartItems.length;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/header.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ALNI ACCESSORIES',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shopping_cart_outlined),
                                color: Colors.black,
                                onPressed: () {
                                  final user =
                                      _profileController.userProfile.value;
                                  if (user == null) {
                                    CustomDialog.showError(
                                      title: 'Peringatan',
                                      message: 'Silahkan login terlebih dahulu',
                                      onConfirm: () {
                                        Get.toNamed(RoutesNamed.login);
                                      },
                                    );
                                    return;
                                  } else {
                                    Get.toNamed(RoutesNamed.cart)?.then((_) {
                                      _loadCartItemCount();
                                    });
                                  }
                                },
                              ),
                              Obx(() {
                                if (_cartItemCount.value > 0) {
                                  return Positioned(
                                    top: -4,
                                    right: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${_cartItemCount.value}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.person_outline),
                            color: Colors.black,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    _buildPointsCard(),
                    const SizedBox(height: 24),
                    _buildCategoriesSection(),
                    const SizedBox(height: 24),
                    _buildBestSellerSection(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/coin.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(width: 24),
              Obx(() {
                if (_profileController.isLoading.value) {
                  return const CircularProgressIndicator();
                }
                final userProfile = _profileController.userProfile.value;
                if (userProfile == null) {
                  return const Text(
                    'Data tidak tersedia',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Poinku',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${userProfile.point}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCategoryItem('assets/img/necklace.png', 'Kalung', () {
              _navigateToProductScreen('Kalung');
            }),
            _buildCategoryItem('assets/img/bracelet.png', 'Gelang', () {
              _navigateToProductScreen('Gelang');
            }),
            _buildCategoryItem('assets/img/ring.png', 'Cincin', () {
              _navigateToProductScreen('Cincin');
            }),
            _buildCategoryItem('assets/img/earrings.png', 'Anting', () {
              _navigateToProductScreen('Anting');
            }),
            _buildCategoryItem('assets/img/more.png', 'Lihat Semua', () {
              _navigateToProductScreen('Semua');
            }),
          ],
        ),
      ],
    );
  }

  void _navigateToProductScreen(String category) {
    Get.to(() => ProductScreen(initialCategory: category));
  }

  Widget _buildBestSellerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Best Seller',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                _homeController.setCurrentIndex(1);
              },
              child: const Text(
                'Lihat Semua',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (_controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
            children: _controller.productList.take(4).map((product) {
              return _buildProductCard(
                product.id,
                product.name,
                'Rp ${product.price}',
                product.image,
                '${product.sold} Terjual',
                product.category,
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryItem(
      String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF3ABEF9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
        Get.toNamed(RoutesNamed.productDetail, arguments: id)?.then((_) {
          _loadCartItemCount();
        });
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
}
