
import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../presentation/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => HomeController());
    //Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
