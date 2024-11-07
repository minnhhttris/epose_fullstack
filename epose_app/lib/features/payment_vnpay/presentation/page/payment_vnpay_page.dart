import 'package:epose_app/features/payment_vnpay/presentation/controller/payment_vnpay_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PaymentVNPayPage extends GetView<PaymentVNPayController> {
  const PaymentVNPayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Thanh toán'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.webViewController.reload(),
          ),
        ],
      ),
      body: Obx(() => Stack(
            children: [
              WebViewWidget(controller: controller.webViewController),
              controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink(),
            ],
          )),
    );
  }
}
