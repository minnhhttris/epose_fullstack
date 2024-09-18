import 'package:epose_app/core/data/pref/prefs';
import 'package:epose_app/features/main/presentation/controller/main_controller.dart';
import 'package:get/get.dart';

class MainBindding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => MainController(Get.find()));
    //Get.lazyPut(() => GetuserUseCase(Get.find(),Get.find()));

  }
}
