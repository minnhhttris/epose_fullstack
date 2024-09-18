import 'package:epose_app/core/data/pref/prefs';
import 'package:epose_app/features/main/nav/profile/presentation/controller/profile_controller.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => ProfileController());
    //Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
