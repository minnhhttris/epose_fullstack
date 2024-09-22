//import 'package:epose_app/core/configs/app_images_string.dart';
import 'package:get/get.dart';

//import '../../../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../../../core/services/user/model/user_model.dart';

class ProfileController extends GetxController {
  // final GetuserUseCase _getuserUseCase;
  // ProfileController(this._getuserUseCase);

  UserModel? user;

  // @override
  // void onInit() async {
  //   super.onInit();
  //   await init();
  // }

  // Future<void> init() async {
  //   user = await _getuserUseCase.getUser();
  // }

  // Cửa hàng của tôi (giả định)
  final myStore = 'Chưa đăng ký'.obs;

  // Điểm thưởng
  final rewardPoints = 0.obs;

}
