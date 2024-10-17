import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../api.config.dart';
import '../../../../core/configs/enum.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/ui/dialogs/dialogs.dart';

class AddInfomationRegisterController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String updateUserEndpoint = 'users/updateUser';

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = TextEditingController();

  var selectedGender = 'Nam'.obs;


  @override
  void onInit() {
    super.onInit();
  }

  Future<void> addInfomation() async {
    final String gender = _mapGenderToEnum(genderController.text);

    final data = {
      "userName": nameController.text,
      "phoneNumbers": phoneController.text,
      "gender": gender,
    };

    try {
      final response = await apiService.postData(
        updateUserEndpoint,
        data,
      );

      DialogsUtils.showAlertDialog2(
        message: response['message'],
        typeDialog: TypeDialog.success,
        title: 'Đã thêm thông tin',
        onPress: () => Get.offNamed(Routes.setPIN),
      );
    } catch (e) {
      Get.snackbar("Có lỗi xảy ra", e.toString());
    }
  }

  String _mapGenderToEnum(String selectedGender) {
    switch (selectedGender) {
      case 'Nam':
        return 'male';
      case 'Nữ':
        return 'female';
      case 'Khác':
        return 'unisex'; 
      default:
        return 'other'; 
    }
  }
}
