
import 'package:epose_app/core/services/user/domain/use_case/save_user_use_case.dart';
import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../presentation/controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => LoginController(Get.find()));
    Get.lazyPut(() => SaveUserUseCase(Get.find()));
  }
}
