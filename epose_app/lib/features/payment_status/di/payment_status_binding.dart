
import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../presentation/controller/payment_status_controller.dart';

class PaymentStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => PaymentStatusController());
  }
}
