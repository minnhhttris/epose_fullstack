import 'package:epose_app/core/data/pref/prefs';
import 'package:epose_app/features/main/nav/clothes/presentation/controller/clothes_controller.dart';
import 'package:get/get.dart';

class ClothesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => ClothesController());
    //Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
