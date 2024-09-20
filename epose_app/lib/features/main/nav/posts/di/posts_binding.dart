import 'package:get/get.dart';

import '../../../../../core/data/pref/prefs';
import '../presentation/controller/posts_controller.dart';

class PostsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => PostsController());
    //Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
