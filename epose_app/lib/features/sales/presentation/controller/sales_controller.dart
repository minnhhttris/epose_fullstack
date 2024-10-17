import 'package:get/get.dart';

import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/user_model.dart';

class SalesController extends GetxController {
 final GetuserUseCase _getuserUseCase;
  SalesController(this._getuserUseCase);

  UserModel? user;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
  }
}
