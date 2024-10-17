import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../api.config.dart';
import '../../../../core/configs/enum.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/ui/dialogs/dialogs.dart';

class RegisterController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String endpoint = 'users/register';

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isObscure = true.obs;

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> register() async {
    if (passwordController.text != confirmPasswordController.text) {
      DialogsUtils.showAlertDialog2(
        message: 'Mật khẩu xác nhận không khớp!',
        typeDialog: TypeDialog.error,
        title: 'Lỗi',
      );
      return;
    }

    final data = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      final response = await apiService.postData(
        endpoint,
        data,
      );

      if (response['success']) {
        DialogsUtils.showAlertDialog2(
          message: response['message'],
          typeDialog: TypeDialog.success,
          title: 'Thành công',
          onPress: () => Get.toNamed(Routes.verifyOTP,
              arguments: [emailController.text, passwordController.text]
          ),
        );
      } else {
        if (response.containsKey('message')) {
          DialogsUtils.showAlertDialog2(
            message: response['message'],
            typeDialog: TypeDialog.error,
            title: 'Lỗi',
          );
        } else if (response.containsKey('errors')) {
          String errorMessage = response['errors'].values.join("\n");
          DialogsUtils.showAlertDialog2(
            message: errorMessage,
            typeDialog: TypeDialog.error,
            title: 'Lỗi đăng ký',
          );
        } else {
          DialogsUtils.showAlertDialog2(
            message: 'Đã xảy ra lỗi không xác định. Vui lòng thử lại!',
            typeDialog: TypeDialog.error,
            title: 'Lỗi',
          );
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Lỗi đăng ký hoặc tài khoản đã tồn tại");
    }
  }
}
