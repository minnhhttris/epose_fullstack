import 'package:get/get.dart';

import '../../../core/data/pref/prefs';
import '../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../presentation/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => GetuserUseCase(Get.find()));
    Get.lazyPut(() => SplashController(Get.find()));
  }
}
