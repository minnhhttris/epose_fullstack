import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isObscure = true.obs;

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

}
