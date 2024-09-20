import 'package:get/get.dart';

import '../../../core/data/pref/prefs';
import '../presentation/controller/main_controller.dart';

class MainBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => MainController());
    //Get.lazyPut(() => GetuserUseCase(Get.find(),Get.find()));

  }
}
