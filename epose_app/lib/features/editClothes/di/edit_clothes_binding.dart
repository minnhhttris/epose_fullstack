
import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../presentation/controller/editClothes_controller.dart';

class EditClothesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => EditClothesController(Get.find()));
    Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
