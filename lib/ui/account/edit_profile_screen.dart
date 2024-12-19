import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsi_app/controller/user_controller.dart';
import 'package:skripsi_app/model/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  String? _initialName;
  String? _initialUsername;
  String? _initialEmail;

  @override
  void initState() {
    super.initState();
    final UserProfile? user = _profileController.userProfile.value;
    _initialName = user?.name;
    _initialUsername = user?.username;
    _initialEmail = user?.email;

    _nameController = TextEditingController(text: _initialName);
    _usernameController = TextEditingController(text: _initialUsername);
    _emailController = TextEditingController(text: _initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3ABEF9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Profil',
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
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/img/header2.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 100,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField('Nama Lengkap', _nameController),
                          const SizedBox(height: 26),
                          _buildTextField('Username', _usernameController),
                          const SizedBox(height: 26),
                          _buildTextField('Email', _emailController),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildSaveProfileButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label wajib diisi';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSaveProfileButton() {
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
            onPressed: _profileController.isLoading.value
                ? null
                : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final updatedProfile = EditProfile(
                        name: _nameController.text.trim() != _initialName
                            ? _nameController.text.trim()
                            : null,
                        username:
                            _usernameController.text.trim() != _initialUsername
                                ? _usernameController.text.trim()
                                : null,
                        email: _emailController.text.trim() != _initialEmail
                            ? _emailController.text.trim()
                            : null,
                      );

                      if (updatedProfile.name != null ||
                          updatedProfile.username != null ||
                          updatedProfile.email != null) {
                        _profileController.editProfile(updatedProfile);
                      } else {
                        Get.snackbar(
                          'Info',
                          'Tidak ada perubahan yang dilakukan',
                          snackPosition: SnackPosition.TOP,
                        );
                      }
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
            child: _profileController.isLoading.value
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
