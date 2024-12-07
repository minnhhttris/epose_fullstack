import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/domain/use_case/save_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class IdentifyUserController extends GetxController {
  final GetuserUseCase _getuserUseCase;
  final SaveUserUseCase _saveUserUseCase;
  IdentifyUserController(this._getuserUseCase, this._saveUserUseCase);

  final apiService = ApiService(apiServiceURL);
  final identityController = TextEditingController();
  var isLoading = false.obs;
  File? frontImage;
  File? backImage;
  String? frontImageUrl;
  String? backImageUrl;
  UserModel? user;
  AuthenticationModel? auth;

  List<File> pickedImages = [];

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
        identityController.text = user!.cccd ?? '';
        frontImageUrl = user!.cccdImg?[0]; 
        backImageUrl = user!.cccdImg?[1];
        if (user!.cccdImg != null && user!.cccdImg!.isNotEmpty) {
          pickedImages = user!.cccdImg!.map((url) => File(url)).toList();
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Có lỗi khi tải dữ liệu: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(bool isFront) async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    isLoading.value = true;
    if (pickedFile != null) {
      if (isFront) {
        frontImage = File(pickedFile.path);
        frontImageUrl = null; 
      } else {
        backImage = File(pickedFile.path);
        backImageUrl = null; 
      }
      update();
      isLoading.value = false;
    }
  }

  void removeImage(bool isFront) {
    if (isFront) {
      frontImage = null;
      frontImageUrl = null;
    } else {
      backImage = null;
      backImageUrl = null;
    }
    update(); 
  }

  Future<void> submitIdentification() async {
    if (identityController.text.isEmpty ||
        (frontImage == null && frontImageUrl == null) ||
        (backImage == null && backImageUrl == null)) {
      Get.snackbar("Error", "Vui lòng nhập CCCD và tải lên hai hình ảnh");
      return;
    }

    isLoading.value = true;
    try {
      print("frontImage: $frontImage");
      print("backImage: $backImage");
      final response = await apiService.postMultipartData(
        'users/updateUser?type=CCCD_img',
        {'CCCD': identityController.text},
        {},
        {
          'CCCD_img': [
            frontImage ?? File(frontImageUrl!),
            backImage ?? File(backImageUrl!)
          ]
        },
        accessToken: auth!.metadata,
      );
      print("response: $response");
      final userUpdate = UserModel.fromJson(response['data']);
      print('userUpdate: $userUpdate');
      await _saveUserUseCase.saveUser(userUpdate);
      print("Save user success");
      Get.snackbar("Success", "Định danh thành công!");
    } catch (e) {
      Get.snackbar("Error", "Có lỗi xảy ra: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
