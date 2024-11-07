
import 'package:epose_app/core/services/user/domain/use_case/save_user_use_case.dart';
import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../presentation/controller/settingInfomation_controller.dart';

class SettingInfomationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => GetuserUseCase(Get.find()));
    Get.lazyPut(() => SaveUserUseCase(Get.find()));
    Get.lazyPut(() => SettingInfomationController(Get.find(), Get.find()));

  }
}
