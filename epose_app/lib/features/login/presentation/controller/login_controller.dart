import 'package:epose_app/core/services/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../api.config.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/user/domain/use_case/save_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';

class LoginController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String LoginEndpoint = 'users/login';
  final String UserEndpoint = 'users/me';

  LoginController(this._saveUserUseCase);
  final SaveUserUseCase _saveUserUseCase;

  UserModel? user;
  AuthenticationModel? auth;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isObscure = true.obs;
  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> login() async {
    final data = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      final loginResponse = await apiService.postData(
        LoginEndpoint,
        data,
      );

      if (loginResponse['success']) {
        auth = AuthenticationModel(
          metadata: loginResponse["accessToken"],
          success: loginResponse["success"],
        );

        final userResponse = await apiService.getData(UserEndpoint, accessToken: auth!.metadata);
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
