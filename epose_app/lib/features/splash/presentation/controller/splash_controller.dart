import 'package:get/get.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';

class SplashController extends GetxController {
  final GetuserUseCase _getuserUseCase;
  SplashController(this._getuserUseCase);
  RxDouble loadingProgress = 0.0.obs;
  @override
  void onInit() {
    print("simulateLoading");
    simulateLoading();
    super.onInit();
  }

  Future<void> simulateLoading() async {
    // for (int i = 0; i <= 10; i++) {
    //   await Future.delayed(const Duration(milliseconds: 20));
    //   loadingProgress.value = i / 100.0;
    // }
    // if (loadingProgress.value == 1.0) {
    //   _getuserUseCase.getUser().then((value) {
    //     if (value != null) {
    //       Get.offNamed(Routes.main);
    //     } else {
    //       Get.offNamed(Routes.login);
    //     }
    //   });
    // }

    _getuserUseCase.getUser().then((value) {
      if (value != null) {
        Get.offNamed(Routes.main);
      } else {
        Get.offNamed(Routes.login);
      }
    });

    
  }

}
