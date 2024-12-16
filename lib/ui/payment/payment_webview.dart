import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsi_app/helper/navigation.dart';
import 'package:skripsi_app/routes/routes_named.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String url;

  const PaymentWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController controller;
  final HomeController _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: const Color(0xFF3ABEF9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _homeController.setCurrentIndex(0);
            Get.offAllNamed(RoutesNamed.state);
          },
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
