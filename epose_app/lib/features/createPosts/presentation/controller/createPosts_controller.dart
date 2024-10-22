import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/posts_model.dart';
import '../../../../core/services/model/store_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class CreatePostsController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getStoreUserEndpoint = 'stores/getStore';
  final GetuserUseCase _getuserUseCase;

  CreatePostsController(this._getuserUseCase);

  UserModel? user;
  StoreModel? store;
  AuthenticationModel? auth;
  PostModel? posts;

  var isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final captionController = TextEditingController();
  final listPicture = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    isLoading.value = true;
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
    getMyStore();
    isLoading.value = false;
  }

  Future<void> getMyStore() async {
    isLoading.value = true;
    try {
      final response = await apiService.getData(getStoreUserEndpoint,
          accessToken: auth!.metadata);
      if (response['success']) {
        store = StoreModel.fromJson(response['data']);
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching store: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPosts(String idStore) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      isLoading.value = true;

      final data = {
        'caption': captionController.text,
        'picture': listPicture,
      };
      try {
        final response = await apiService.postData('posts/create',
            accessToken: auth!.metadata,
            data, 
            );
        if (response['success']) {

          Get.snackbar("Success", "Post created successfully");
          
        }
      } catch (e) {
        Get.snackbar("Error", "Error creating post: ${e.toString()}");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void removeImage(File image) {
    listPicture.remove(image);
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    listPicture
        .addAll(pickedImages.map((image) => File(image.path)).toList());
  }

  bool check_list_empty() {
    return listPicture.isEmpty;
  }
}
