import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../presentation/controller/clothes_controller.dart';

class ClothesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => ClothesController());
    //Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
