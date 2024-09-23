import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/user/model/user_model.dart';

class SettingInfomationController extends GetxController {
  // final GetuserUseCase _getuserUseCase;
  // ProfileController(this._getuserUseCase);

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final phoneController = TextEditingController();
  final identityController = TextEditingController();

  UserModel? user;

  var selectedGender = '  Nam'.obs; 

  // @override
  // void onInit() async {
  //   super.onInit();
  //   await init();
  // }

  // Future<void> init() async {
  //   user = await _getuserUseCase.getUser();
  // }
}
