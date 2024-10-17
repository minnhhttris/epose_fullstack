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
    auth = await _getuserUseCase.getToken();
    getMyStore();
    isLoading.value = false;
  }

  Future<void> getMyStore() async {
    isLoading.value = true;
    try {
      final response = await apiService.getData(getStoreUserEndpoint,
          accessToken: auth!.metadata);
      if (response['success']) {
        store = StoreModel.fromJson(response['data']);
        myStore.value = true;
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching store: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // Điểm thưởng
  final rewardPoints = 0.obs;
}
