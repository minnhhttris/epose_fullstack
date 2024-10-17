import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../api.config.dart';
import '../../../../core/configs/enum.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/user/domain/use_case/save_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';
import '../../../../core/ui/dialogs/dialogs.dart';

class VerifyOTPController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String verifyOtpEndpoint = 'users/verify-otp';
  final String resendOtpEndpoint = 'users/resend-otp';
  final String loginEndpoint = 'users/login';
  final String userEndpoint = 'users/me';

  VerifyOTPController(this._saveUserUseCase);
  final SaveUserUseCase _saveUserUseCase;

  UserModel? user;
  AuthenticationModel? auth;

  var countdown = 60.obs;
  final otpController = TextEditingController();

  final String email = Get.arguments[0];
  final String password = Get.arguments[1];


  @override
  void onInit() {
    super.onInit();
    print('Email: $email');
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
          onPress: () => login(),
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
          Get.snackbar("Thông báo", response['message'] ?? " ");
          startCountdown();
        } else {
          Get.snackbar("Lỗi", response['message'] ?? " ");
        }
      } catch (e) {
        Get.snackbar("Có lỗi xảy ra", e.toString());
      }
    }
  }

  Future<void> login() async {
    final data = {
      "email": email,
      "password": password,
    };

    try {
      final loginResponse = await apiService.postData(
        loginEndpoint,
        data,
      );

      if (loginResponse['success']) {
        auth = AuthenticationModel(
          metadata: loginResponse["accessToken"],
          success: loginResponse["success"],
        );

        final userResponse =
            await apiService.getData(userEndpoint, accessToken: auth!.metadata);
        if (userResponse['success']) {
          user = UserModel.fromJson(userResponse['data']);
        }

        await _saveUserUseCase.saveUser(user!);
        await _saveUserUseCase.saveToken(auth!);
        Get.snackbar("Thành công", "Đăng nhập thành công");
        Get.offAllNamed(Routes.main);
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Có lỗi xảy ra", e.toString());
    }
  }
}
