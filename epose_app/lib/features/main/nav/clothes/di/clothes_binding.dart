import 'package:epose_app/core/data/pref/prefs';
//import 'package:epose_app/features/main/nav/home/presentation/controller/home_controller.dart';
import 'package:get/get.dart';

class ClothesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    //Get.lazyPut(() => HomeController(Get.find()));
    //Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
