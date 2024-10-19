
import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../presentation/controller/clothesByStyle_controller.dart';

class ClothesByStyleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => ClothesByStyleController(Get.find()));
    Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
