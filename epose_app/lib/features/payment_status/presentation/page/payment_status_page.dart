import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/routes.dart';
import '../controller/payment_status_controller.dart';

class PaymentStatusPage extends GetView<PaymentStatusController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Trạng thái thanh toán'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          bodystatus(),
          buttonBackMain(),
        ],
      ),
    );
  }

  Widget buttonBackMain() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: ButtonWidget(
        ontap: () {
          Get.offNamed(Routes.splash);
        },
        text: 'Trở về trang chủ',
      ),
    );
  }

  Widget bodystatus() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return Column(
                children: [
                  Icon(
                    controller.paymentStatus.value
                        ? Icons.check_circle
                        : Icons.error,
                    color: controller.paymentStatus.value
                        ? Colors.green
                        : Colors.red,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    controller.paymentStatus.value
                        ? 'Thanh toán thành công'
                        : 'Thanh toán thất bại',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    controller.message.value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
