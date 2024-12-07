import 'package:epose_app/core/services/user/model/auth_model.dart';
import 'package:get/get.dart';

import '../../../../../../api.config.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../../../../core/services/api.service.dart';
import '../../../../../../core/services/model/store_model.dart';
import '../../../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../../../core/services/user/model/user_model.dart';

class ProfileController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;
  ProfileController(this._getuserUseCase);

  UserModel? user;
  AuthenticationModel? auth;
  StoreModel? store; 
  var isLoading = false.obs;
  var myStore = false.obs; 
  var isStoreActive = false.obs; 

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    isLoading.value = true;
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
    await getMyStore();
    isLoading.value = false;
  }

  Future<void> getMyStore() async {
    myStore.value = false;
    isStoreActive.value = false;

    if (user == null || auth == null) return;
    var userId = user!.idUser;
    rewardPoints.value = user!.coins;
    try {
      print('userId: $userId');
      final response = await apiService.getData('stores/user/$userId',
          accessToken: auth!.metadata);

      if (response['success']) {
        store = StoreModel.fromJson(response['data']);

        if (store != null && store!.idUser == user!.idUser) {
          myStore.value = true; 
          final String status = store!.status.toString().split('.').last;
          isStoreActive.value = status == 'active';
        }
      }
    } catch (e) {
      print(e);
      // Get.snackbar("Error", "Có lỗi xảy ra khi lấy thông tin cửa hàng.");
    }
  }

  void handleStoreNavigation() {
    if (!isUserInfoComplete(user)) {
      Get.snackbar(
        "Thông báo",
        "Vui lòng hoàn thiện thông tin cá nhân trước khi tạo cửa hàng.",
      );
      return;
    }

    if (myStore.value) {
      if (isStoreActive.value) {
        // Cửa hàng active
        Get.toNamed(Routes.store, arguments: store);
      } else {
        // Cửa hàng inactive
        Get.snackbar(
          "Thông báo",
          "Bạn đã tạo cửa hàng rồi, hãy chờ được duyệt nhé.",
        );
      }
    } else {
      // Chưa có cửa hàng
      Get.toNamed(Routes.createStore);
    }
  }

  void handleNavigationToCoins() {
    Get.toNamed(Routes.coins);
  }

  bool isUserInfoComplete(user) {
    if (user == null) return false;
    return user.userName != null &&
        user.phoneNumbers != null &&
        user.address != null &&
        user.cccd != null &&
        user.cccdImg != null &&
        user.gender != null &&
        user.dateOfBirth != null;
  }

  // Điểm thưởng
  final rewardPoints = 0.obs;
}
