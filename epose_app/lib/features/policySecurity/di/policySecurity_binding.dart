
import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../presentation/controller/policySecurity_controller.dart';

class PolicySecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => PolicySecurityController());
    Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
