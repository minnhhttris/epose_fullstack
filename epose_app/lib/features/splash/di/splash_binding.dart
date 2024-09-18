import 'package:epose_app/core/data/pref/prefs';
import 'package:epose_app/features/splash/presentation/controller/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    // Get.lazyPut(() => GetuserUseCase(Get.find()));
    Get.lazyPut(() => SplashController());
  }
}
