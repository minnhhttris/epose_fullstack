
import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../presentation/controller/payment_status_controller.dart';

class PaymentStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => PaymentStatusController(Get.find()));
    Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
