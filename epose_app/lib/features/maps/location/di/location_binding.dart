import 'package:epose_app/core/data/pref/prefs';
import 'package:epose_app/features/maps/location/presentation/controller/location_controller.dart';
import 'package:get/get.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => LocationController());
  }
}
