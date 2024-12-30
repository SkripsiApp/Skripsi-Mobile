import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'dart:convert';
import 'package:skripsi_app/controller/address_controller.dart';
import 'package:skripsi_app/model/address_model.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _subdistrictController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _phoneController = TextEditingController();

  final AddressController _addressControllerInstance =
      Get.find<AddressController>();

  String? selectedProvince;
  String? selectedCity;
  List<String> cityList = [];

  Map<String, List<String>> citiesByProvince = {};

  @override
  void initState() {
    super.initState();
    _loadCitiesData();
  }

  Future<void> _loadCitiesData() async {
    // Load the JSON file from assets
    final String response =
        await root_bundle.rootBundle.loadString('assets/data/city.json');
    final Map<String, dynamic> data = jsonDecode(response);

    setState(() {
      citiesByProvince = data.map<String, List<String>>((key, value) {
        return MapEntry(key, List<String>.from(value));
      });
      _initializeFields();
    });
  }

  void _initializeFields() {
    final AddressModel address = Get.arguments;
    _nameController.text = address.name;
    _addressController.text = address.address;
    selectedCity = address.city;
    _subdistrictController.text = address.subdistric;
    _zipCodeController.text = address.zipCode;
    _phoneController.text = address.phone;

    // Set selectedProvince based on selectedCity
    citiesByProvince.forEach((province, cities) {
      if (cities.contains(selectedCity)) {
        selectedProvince = province;
        cityList = cities;
      }
    });

    // Ensure selectedCity is in the cityList
    if (!cityList.contains(selectedCity)) {
      selectedCity = null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _subdistrictController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3ABEF9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Alamat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildInputField(
                      'Nama Penerima',
                      controller: _nameController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Nama penerima wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    _buildInputField(
                      'Alamat Lengkap',
                      controller: _addressController,
                      maxLines: 3,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Alamat wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    _buildProvinceDropdown(),
                    const SizedBox(height: 24),
                    _buildCityDropdown(),
                    const SizedBox(height: 24),
                    _buildInputField(
                      'Kecamatan',
                      controller: _subdistrictController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Kecamatan wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    _buildInputField(
                      'Kode Pos',
                      controller: _zipCodeController,
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Kode pos wajib diisi'
                          : (value.length != 5
                              ? 'Kode pos harus 5 digit'
                              : null),
                    ),
                    const SizedBox(height: 24),
                    _buildInputField(
                      'Nomor Telepon',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Nomor telepon wajib diisi'
                          : (value.length < 10
                              ? 'Nomor telepon tidak valid'
                              : null),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildSaveAddressButton(Get.arguments),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label, {
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.lightBlue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProvinceDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Provinsi',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.lightBlue),
            ),
          ),
          value: selectedProvince,
          items: citiesByProvince.keys
              .map((province) => DropdownMenuItem<String>(
                    value: province,
                    child: Text(province,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedProvince = value;
              selectedCity = null; // Reset city selection
              cityList = citiesByProvince[value!] ?? [];
            });
          },
        ),
      ],
    );
  }

  Widget _buildCityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Kota / Kabupaten',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.lightBlue),
            ),
          ),
          value: selectedCity,
          items: cityList
              .map((city) => DropdownMenuItem<String>(
                    value: city,
                    child: Text(city,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedCity = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSaveAddressButton(AddressModel address) {
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
      child: Obx(() {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _addressControllerInstance.isLoading.value
                ? null
                : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final updatedAddress = AddressModel(
                        id: address.id, // Preserve the original address ID
                        name: _nameController.text.trim(),
                        address: _addressController.text.trim(),
                        city: selectedCity ?? '',
                        subdistric: _subdistrictController.text.trim(),
                        zipCode: _zipCodeController.text.trim(),
                        phone: _phoneController.text.trim(),
                      );

                      _addressControllerInstance.updateAddress(updatedAddress);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3ABEF9),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _addressControllerInstance.isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
