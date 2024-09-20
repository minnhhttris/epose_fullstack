import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../presentation/controller/bill_controller.dart';

class BillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => BillController());
    //Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
