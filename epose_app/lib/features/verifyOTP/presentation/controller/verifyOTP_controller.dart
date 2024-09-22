import 'package:get/get.dart';

import '../../../../core/routes/routes.dart';

class VerifyOTPController extends GetxController {
  var countdown = 60.obs; // Biến đếm ngược thời gian

  @override
  void onInit() {
    super.onInit();
    startCountdown();
  }

  // Hàm đếm ngược thời gian
  void startCountdown() {
    countdown.value = 60; // Đặt giá trị ban đầu
    Future.delayed(const Duration(seconds: 1), () {
      if (countdown.value > 0) {
        countdown.value--;
        startCountdown(); // Gọi lại hàm để tiếp tục đếm ngược
      }
    });
  }

  // Hàm xử lý gửi lại mã OTP
  void resendOtp() {
    if (countdown.value == 0) {
      countdown.value = 60; // Reset lại thời gian đếm ngược
      startCountdown();
      // Gửi lại mã OTP, thêm logic ở đây
      print('OTP resent!');
    }
  }

  // Hàm xử lý xác nhận mã OTP
  void verifyOtp(String otp) {
    print('OTP entered: $otp');
    Get.offNamed(Routes.main);
  }
}
