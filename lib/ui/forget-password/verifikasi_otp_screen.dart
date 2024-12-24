import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skripsi_app/controller/forget_password_controller.dart';
import 'package:skripsi_app/ui/forget-password/new_password_screen.dart';

class VerifikasiOTPScreen extends StatefulWidget {
  final String email;

  const VerifikasiOTPScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifikasiOTPScreen> createState() => _VerifikasiOTPScreenState();
}

class _VerifikasiOTPScreenState extends State<VerifikasiOTPScreen> {
  final ForgetPasswordController controller = Get.find<ForgetPasswordController>();
  final int numberOfFields = 6;
  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < numberOfFields; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void nextField(String value, int index) {
    if (value.length == 1 && index < numberOfFields - 1) {
      focusNodes[index + 1].requestFocus();
    }
  }

  void previousField(String value, int index) {
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> handleVerifyOTP() async {
    String otp = controllers.map((c) => c.text).join();

    if (otp.length != numberOfFields) {
      Get.snackbar(
        'Error',
        'Silakan masukkan kode OTP lengkap',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await controller.verifyOTP(widget.email, otp);

    // Check response status and navigate if successful
    if (controller.response?.status == true &&
        controller.response?.data != null) {
      Get.to(() => NewPasswordScreen(token: controller.response!.data!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3ABEF9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Lupa Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Verifikasi OTP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Masukkan OTP untuk verifikasi pemulihan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masukkan Kode Otp',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    numberOfFields,
                    (index) => SizedBox(
                      width: 45,
                      child: TextField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9]')),
                          UpperCaseTextFormatter(),
                        ],
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFF40C4FF)),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            nextField(value, index);
                          } else {
                            previousField(value, index);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : handleVerifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF40C4FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Konfirmasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom formatter to convert text to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
