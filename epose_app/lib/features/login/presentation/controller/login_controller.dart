import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/user/domain/use_case/save_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';

class LoginController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String endpoint = 'users/login';

  LoginController(this._saveUserUseCase);
  final  SaveUserUseCase _saveUserUseCase;

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
      final response = await apiService.postData(
        endpoint,
        data,
      );
      final authentication = AuthenticationModel(
          metadata: response["accessToken"], success: response["success"]);
      _saveUserUseCase.saveToken(authentication);
      Get.toNamed('/main');
    } catch (e) {
      print('Error: $e');
    }
  }
}
