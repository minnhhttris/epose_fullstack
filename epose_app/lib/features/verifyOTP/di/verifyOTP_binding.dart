
import 'package:epose_app/core/services/user/domain/use_case/save_user_use_case.dart';
import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../presentation/controller/verifyOTP_controller.dart';

class VerifyOTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => VerifyOTPController(Get.find()));
    Get.lazyPut(() => SaveUserUseCase(Get.find()));
    Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
