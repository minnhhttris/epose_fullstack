import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../api.config.dart';
import '../../../../core/configs/enum.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/ui/dialogs/dialogs.dart';

class VerifyOTPController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String verifyOtpEndpoint = 'users/verify-otp';
  final String resendOtpEndpoint = 'users/resend-otp';

  var countdown = 60.obs;
  final otpController = TextEditingController();

  final String email = Get.arguments; 

  @override
  void onInit() {
    super.onInit();
    startCountdown();
  }

  // Hàm đếm ngược thời gian
  void startCountdown() {
    countdown.value = 60;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  // Hàm gửi mã OTP và xác thực
  Future<void> verifyOtp() async {
    final data = {
      "email": email, 
      "otp": otpController.text,
    };

    try {
      final response = await apiService.postData(verifyOtpEndpoint, data);

      if (response['success']) {
        DialogsUtils.showAlertDialog2(
          message: response['message'],
          typeDialog: TypeDialog.success,
          title: 'Đã xác thực',
          onPress: () => Get.offNamed(Routes.addInfomationRegister),
        );
      } else {
        Get.snackbar("Lỗi", response['message'] ?? "Xác thực OTP thất bại.");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Xác thực OTP thất bại. Vui lòng thử lại.");
      print("Error verifying OTP: $e");
    }
  }

  // Gửi lại OTP
  Future<void> resendOtp() async {
    if (countdown.value == 0) {
      final dataresend = {"email": email};
      try {
        final response =
            await apiService.postData(resendOtpEndpoint, dataresend);

        if (response['success'] == true) {
          Get.snackbar("Thông báo", response['message'] ?? "Đã gửi lại OTP.");
          countdown.value = 60;
          startCountdown();
        } else {
          Get.snackbar("Lỗi", response['message'] ?? "Không thể gửi lại OTP.");
        }
      } catch (e) {
        Get.snackbar("Lỗi", "Gửi lại OTP thất bại. Vui lòng thử lại.");
        print("Error resending OTP: $e");
      }
    }
  }
}
