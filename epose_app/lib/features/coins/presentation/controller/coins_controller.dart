import 'package:get/get.dart';
import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/domain/use_case/save_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class CoinsController extends GetxController {
  final GetuserUseCase _getuserUseCase;
  final SaveUserUseCase _saveUserUseCase;
  CoinsController(this._getuserUseCase, this._saveUserUseCase);

  final apiService = ApiService(apiServiceURL);
  var isLoading = false.obs;
  var attendanceDays = List<bool>.filled(7, false).obs; // Trạng thái điểm danh
  UserModel? user;
  AuthenticationModel? auth;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    isLoading.value = true;
    try {
      user = await _getuserUseCase.getUser();
      auth = await _getuserUseCase.getToken();
      await fetchAttendance();
    } catch (e) {
      Get.snackbar("Error", "Có lỗi khi tải dữ liệu: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAttendance() async {
    try {
      final response = await apiService.getData("attendance/${user!.idUser}",
          accessToken: auth?.metadata);
      if (response['success']) {
        attendanceDays.value = List<bool>.from(response['data']);
      }
    } catch (e) {
      Get.snackbar("Error", "Không thể tải dữ liệu điểm danh: ${e.toString()}");
    }
  }

  Future<void> checkIn() async {
    isLoading.value = true;
    try {
      final response = await apiService.postData("attendance/checkin", {},
          accessToken: auth?.metadata);

      if (response['success']) {
        await fetchAttendance();
        Get.snackbar("Thành công", "Điểm danh thành công! +1000 xu");
      } else {
        Get.snackbar("Thông báo", response['message']);
      }
    } catch (e) {
      Get.snackbar("Error", "Không thể điểm danh: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
