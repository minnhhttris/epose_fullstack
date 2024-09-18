import 'package:epose_app/core/data/pref/prefs';
import 'package:epose_app/features/main/nav/posts/presentation/controller/posts_controller.dart';
import 'package:get/get.dart';

class PostsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Prefs(), fenix: true);
    Get.lazyPut(() => PostsController());
    //Get.lazyPut(() => GetuserUseCase(Get.find()));
  }
}
