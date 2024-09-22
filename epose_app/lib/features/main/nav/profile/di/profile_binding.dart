import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../presentation/controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => ProfileController());
    //Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
