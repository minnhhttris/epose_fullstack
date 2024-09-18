import 'package:epose_app/core/data/pref/prefs';
import 'package:epose_app/features/main/nav/bill/presentation/controller/bill_controller.dart';
import 'package:get/get.dart';

class BillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => BillController());
    //Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
