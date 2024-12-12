import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsi_app/controller/address_controller.dart';
import 'package:skripsi_app/model/address_model.dart';
import 'package:skripsi_app/routes/routes_named.dart';

class AddressList extends StatefulWidget {
  const AddressList({super.key});

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  final AddressController _addressController = Get.put(AddressController());

  @override
  void initState() {
    super.initState();
    _addressController.fetchAddress();
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
          'Daftar Alamat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Obx(() {
            if (_addressController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (_addressController.addressList.isEmpty) {
              return const Center(child: Text('Tidak ada alamat tersimpan'));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: _addressController.addressList.length,
                itemBuilder: (context, index) {
                  final address = _addressController.addressList[index];
                  return Obx(() => Column(
                        children: [
                          _buildAddressCard(
                            address: address,
                            isSelected: _addressController
                                .isAddressSelected(address.id),
                            onEdit: () {
                              // Implement edit functionality
                            },
                            onDelete: () {
                              // Implement delete functionality
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ));
                },
              );
            }
          }),
          Positioned(
            right: 16,
            bottom: 120,
            child: FloatingActionButton(
              onPressed: () {
                Get.toNamed(RoutesNamed.addAddress);
              },
              backgroundColor: const Color(0xFF3ABEF9),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildSelectAddressButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required AddressModel address,
    required bool isSelected,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: () {
        _addressController.selectAddress(address.id);
      },
      child: Obx(() => Container(
            decoration: BoxDecoration(
              color: _addressController.isAddressSelected(address.id)
                  ? const Color(0xFFA7E6FF)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        address.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: onEdit,
                        child: const Text(
                          'Ubah',
                          style: TextStyle(
                            color: Color(0xFF3ABEF9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${address.city}, ${address.subdistric}',
                    style: const TextStyle(
                      color: Color(0xFF9098B1),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        address.address,
                        style: const TextStyle(
                          color: Color(0xFF9098B1),
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildSelectAddressButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: Obx(() {
          final selectedAddress =
              _addressController.addressList.firstWhereOrNull(
            (address) =>
                address.id == _addressController.selectedAddressId.value,
          );

          return ElevatedButton(
            onPressed: selectedAddress != null
                ? () {
                    Navigator.pop(context, selectedAddress);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3ABEF9),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Pilih Alamat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
      ),
    );
  }
}
