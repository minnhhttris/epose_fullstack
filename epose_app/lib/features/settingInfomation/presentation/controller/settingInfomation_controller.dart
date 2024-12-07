import 'dart:io';

import 'package:epose_app/core/services/user/domain/use_case/save_user_use_case.dart';
import 'package:epose_app/core/services/user/model/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/clothes_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/user_model.dart';

class SettingInfomationController extends GetxController {
  final GetuserUseCase _getuserUseCase;
  final SaveUserUseCase _saveUserUseCase;
  SettingInfomationController(this._getuserUseCase, this._saveUserUseCase);

  final apiService = ApiService(apiServiceURL);
  final String endpoint = 'users/updateUser';

  var isLoading = false.obs;

  UserModel? user;
  AuthenticationModel? auth;

  final Map<Gender, String> genderDisplayMap = {
    Gender.male: 'Nam',
    Gender.female: 'Nữ',
    Gender.unisex: 'Unisex',
    Gender.other: 'Khác'
  };

  final Map<String, Gender> genderValueMap = {
    'Nam': Gender.male,
    'Nữ': Gender.female,
    'Unisex': Gender.unisex,
    'Khác': Gender.other
  };

  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final phoneController = TextEditingController();
  final identityController = TextEditingController();
  final addressController = TextEditingController();

  var selectedGender = Gender.other.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    isLoading.value = true;
    try {
      user = await _getuserUseCase.getUser();
      auth = await _getuserUseCase.getToken();
      if (user != null) {
        nameController.text = user!.userName ?? '';
        phoneController.text = user!.phoneNumbers ?? '';
        dateOfBirthController.text = user!.dateOfBirth != null
            ? DateFormat('dd/MM/yyyy').format(user!.dateOfBirth!)
            : '';
        identityController.text = user!.cccd ?? 'Định danh tài khoản của bạn!';
        addressController.text = user!.address ?? 'Thêm địa chỉ của bạn!';
        selectedGender.value = genderFromString(user!.gender);
      }
    } catch (e) {
      Get.snackbar("Error", "Có lỗi khi tải dữ liệu: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateInformation() async {

    DateTime? dob = DateFormat('dd/MM/yyyy')
        .parse(dateOfBirthController.text, true)
        .toUtc();

    final data = {
      "userName": nameController.text,
      "phoneNumbers": phoneController.text,
      "gender": selectedGender.value.toString().split('.').last,
      "dateOfBirth": dob.toIso8601String(),
    };

    isLoading.value = true;
    print(
        "Gender to be sent: ${selectedGender.value.toString().split('.').last}");
    try {
      final response = await apiService.postData(endpoint, data,
          accessToken: auth!.metadata);
      final userUpdate = UserModel.fromJson(response['data']);
      user = userUpdate;
      await _saveUserUseCase.saveUser(userUpdate);
      selectedGender.value = genderFromString(userUpdate.gender); 
      Get.snackbar("Success", "Cập nhật thông tin thành công");
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Có lỗi xảy ra: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Gender genderFromString(String? genderString) {
    switch (genderString?.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'unisex':
        return Gender.unisex;
      default:
        return Gender.other;
    }
  }

  final picker = ImagePicker();
  File? imgAvatar;

  Future<void> selectImageAvatar() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      imgAvatar = File(pickedFile.path);

      isLoading.value = true;
      try {
        final response = await apiService.postMultipartData(
          'users/updateUser?type=avatar',
          {},
          {'avatar': imgAvatar!},
          {},
          accessToken: auth!.metadata,
        );

        final userUpdateAvatar = UserModel.fromJson(response['data']);
        await _saveUserUseCase.saveUser(userUpdateAvatar);
        Get.snackbar("Success", "Cập nhật avatar thành công");
      } catch (e) {
        print(e);
        Get.snackbar(
            "Error", "Có lỗi xảy ra khi cập nhật avatar: ${e.toString()}");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
