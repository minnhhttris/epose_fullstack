import 'package:get/get.dart';
import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class PaymentStatusController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;

  PaymentStatusController(this._getuserUseCase);

  UserModel? user;
  AuthenticationModel? auth;

  var paymentStatus = true.obs;
  var message = "".obs;

  final dynamic data = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    init();
    String updatedData = data.toString().replaceAll("localhost", "10.0.2.2");
    fetchPaymentStatus(updatedData);
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
  }

  // Hàm gọi API để kiểm tra trạng thái thanh toán
  Future<void> fetchPaymentStatus(String fullUrl) async {
    try {
      final responseData = await apiService.getDataFromUrl(fullUrl);
      if (responseData["success"] == true) {
        paymentStatus.value = true;
        message.value = responseData["msg"] ?? "Thanh toán thành công";
        await handleSuccessfulPayment(responseData["data"]);
      } else {
        paymentStatus.value = false;
        message.value = responseData["msg"] ?? "Thanh toán thất bại";
      }
    } catch (e) {
      paymentStatus.value = false;
      message.value = "Có lỗi xảy ra khi gọi API";
      print("Lỗi khi gọi API: $e");
    }
  }

  // Xử lý khi thanh toán thành công
  Future<void> handleSuccessfulPayment(Map<String, dynamic> data) async {
    try {
      // Cập nhật số lượng quần áo theo từng sản phẩm trong billItems
      for (var item in data["billItems"]) {
        await updateClothes(item["idItem"], item["size"], item["quantity"]);
        await removeItemFromBag(item["idItem"], item["size"]);
      }
    } catch (e) {
      print("Lỗi khi cập nhật sau thanh toán thành công: $e");
    }
  }

  // Cập nhật số lượng quần áo
  Future<void> updateClothes(String idItem, String size, int quantity) async {
    try {
      final response = await apiService.postData(
        'clothes/$idItem/updateQuantity',
        {'size': size, 'quantityChange': -quantity},
        accessToken: auth?.metadata,
      );
      if (response['success']) {
        print(
            "Cập nhật số lượng quần áo thành công cho $idItem với kích cỡ $size");
      } else {
        print("Lỗi khi cập nhật số lượng quần áo: ${response['msg']}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update clothes: ${e.toString()}");
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeItemFromBag(String idItem, String size) async {
    try {
      final response = await apiService.deleteData(
        'bagShopping/$idItem',
        data: {'size': size},
        accessToken: auth?.metadata,
      );
      if (response['success']) {
        print("Đã xóa sản phẩm khỏi giỏ hàng: $idItem với kích cỡ $size");
      } else {
        print("Lỗi khi xóa sản phẩm khỏi giỏ hàng: ${response['msg']}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to remove item from bag: ${e.toString()}");
    }
  }
}
