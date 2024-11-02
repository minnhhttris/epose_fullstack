import 'package:epose_app/core/services/user/model/auth_model.dart';
import 'package:get/get.dart';

import '../../../../../../api.config.dart';
import '../../../../../../core/services/api.service.dart';
import '../../../../../../core/services/model/store_model.dart';
import '../../../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../../../core/services/user/model/user_model.dart';

class ProfileController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getStoreUserEndpoint = 'stores/getStore';
  final GetuserUseCase _getuserUseCase;
  ProfileController(this._getuserUseCase);

  UserModel? user;
  AuthenticationModel? auth;
  StoreModel? store;
  var isLoading = false.obs;
  var myStore = false.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    isLoading.value = true;
    user = await _getuserUseCase.getUser();
    print(user!.idUser.toString());
    auth = await _getuserUseCase.getToken();
    getMyStore();
    isLoading.value = false;
  }

  Future<void> getMyStore() async {
    myStore.value = false;
    try {
      final response = await apiService.getData(getStoreUserEndpoint,
          accessToken: auth!.metadata);
      print(response);
      if (response['success']) {
        StoreModel tempStore = StoreModel.fromJson(response['data']);

        // Kiểm tra nếu cửa hàng trả về thuộc về người dùng hiện tại
        if (tempStore.idUser == user!.idUser) {
          store = tempStore;
          myStore.value = true;
        } else {
          myStore.value = false;
          Get.snackbar("Error", "Bạn không sở hữu cửa hàng này.");
        }
        myStore.value = true;
      }
    } catch (e) {
      print(e);
      //Get.snackbar("Error", "Error fetching store: ${e.toString()}");
    } 
  }

  // Điểm thưởng
  final rewardPoints = 0.obs;
}
