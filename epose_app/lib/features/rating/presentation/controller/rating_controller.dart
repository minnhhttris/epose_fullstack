import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/clothes_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class RatingController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;
  RatingController(this._getuserUseCase);

  final String idItem = Get.arguments;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  var isLoading = false.obs;

  UserModel? user;
  AuthenticationModel? auth;
  ClothesModel? clothes;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
  }


}
