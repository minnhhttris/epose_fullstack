import 'package:get/get.dart';
import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';

class PaymentStatusController extends GetxController {
  final apiService = ApiService(apiServiceURL);

  var paymentStatus = true.obs;
  var message = "".obs; 

  final dynamic data = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    // Thay 'localhost' bằng '10.0.2.2' cho Android emulator
    String updatedData = data.toString().replaceAll("localhost", "10.0.2.2");
    print("Updated URL: $updatedData");

    fetchPaymentStatus(updatedData);
  }

  // Hàm gọi API để kiểm tra trạng thái thanh toán
  Future<void> fetchPaymentStatus(String fullUrl) async {
    try {
      final responseData = await apiService.getDataFromUrl(fullUrl);
      print("Dữ liệu trả về từ API: $responseData");

      if (responseData["success"] == true) {
        paymentStatus.value = true;
        message.value = responseData["msg"] ?? "Thanh toán thành công";
        print("Đã cập nhật trạng thái thanh toán: Thành công");
      } else {
        paymentStatus.value = false;
        message.value = responseData["msg"] ?? "Thanh toán thất bại";
        print("Đã cập nhật trạng thái thanh toán: Thất bại");
      }
    } catch (e) {
      paymentStatus.value = false;
      message.value = "Có lỗi xảy ra khi gọi API";
      print("Lỗi khi gọi API: $e");
    }
  }
}
