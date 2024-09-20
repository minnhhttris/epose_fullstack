import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //final GetuserUseCase _getuserUseCase;

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
}
