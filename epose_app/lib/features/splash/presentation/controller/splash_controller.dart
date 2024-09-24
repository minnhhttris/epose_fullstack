import 'package:get/get.dart';
import '../../../../core/data/pref/prefs';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';

class SplashController extends GetxController {
  final GetuserUseCase _getuserUseCase;
  SplashController(this._getuserUseCase);
  RxDouble loadingProgress = 0.0.obs;
  RxDouble loadingValue =
      0.0.obs; // Sử dụng RxDouble để nhất quán với loadingProgress

  @override
  void onInit() {
    super.onInit();
    print("simulateLoading");
    simulateLoading();
  }

  Future<void> simulateLoading() async {

    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 30), () {
        loadingValue.value = i / 100;
      });
    }
    await Future.delayed(const Duration(seconds: 3));

    bool? isFirstLaunch = await Prefs.preferences.getBool('isFirstLaunch');

    if (isFirstLaunch == null || isFirstLaunch) {
      await Prefs.preferences.setBool('isFirstLaunch', false);
      Get.offNamed(Routes.onboarding);
    } else {
      try {
        var user = await _getuserUseCase.getUser();
        if (user != null) {
          Get.offNamed(Routes.main);
        } else {
          Get.offNamed(Routes.login);
          //Get.offNamed(Routes.settingInfomation);
        }
      } catch (error) {
        // Xử lý lỗi khi gọi getUser
        Get.offNamed(Routes.login);
      }
    }
  }
}
