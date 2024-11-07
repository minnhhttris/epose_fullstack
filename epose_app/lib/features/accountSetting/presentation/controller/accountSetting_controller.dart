import 'package:epose_app/core/services/model/store_model.dart';
import 'package:get/get.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/user_model.dart';

class AccountSettingController extends GetxController {
  final GetuserUseCase _getuserUseCase;
  AccountSettingController(this._getuserUseCase);

  UserModel? user;
  StoreModel? store;
  var myStore = false.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
  }

  Future<void> logout() async {
    await _getuserUseCase.logout();
    Get.offAllNamed(Routes.login);
  }
}
