import 'package:epose_app/core/data/pref/prefs';
import 'package:get/get.dart';

class MapsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    
  }

}


