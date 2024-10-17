import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/clothes_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class DetailsClothesController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;
  DetailsClothesController(this._getuserUseCase);

  final String idItem = Get.arguments;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  var isLoading = false.obs;

  var isExpanded = false.obs;
  var isFavorited = false.obs;
  var favoriteCount = 0.obs;
  var currentImageIndex = 0.obs;

  final TextEditingController commentController = TextEditingController();

  UserModel? user;
  AuthenticationModel? auth;
  ClothesModel? clothes;

  @override
  void onInit() {
    super.onInit();
    init();
    getClothesById(idItem);
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
  }

  Future<void> getClothesById(String postId) async {
    isLoading.value = true;

    final response = await apiService.getData('clothes/$idItem');

    if (response['success'] == true) {
      clothes = ClothesModel.fromJson(response['posts'], );
    } else {
      Get.snackbar("Error", "Failed to fetch post");
    }

    isLoading.value = false;
    update();
  }


}
