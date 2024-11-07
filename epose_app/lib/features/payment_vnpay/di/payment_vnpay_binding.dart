import 'package:epose_app/features/payment_vnpay/presentation/controller/payment_vnpay_controller.dart';
import 'package:get/get.dart';


class PaymentVNPayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentVNPayController());
  }
}
