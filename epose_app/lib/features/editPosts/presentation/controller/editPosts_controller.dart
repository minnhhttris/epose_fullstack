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

class EditPostsController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;

  EditPostsController(this._getuserUseCase);

  UserModel? user;
  StoreModel? store;
  AuthenticationModel? auth;
  PostModel? posts;

  var isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final captionController = TextEditingController();
  final listPicture = <File>[].obs;
  final listLocalPictures = <File>[].obs; 
  final listRemotePictures = <String>[].obs;
  final combinedPictures = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    final idPosts = Get.arguments as String; 
    init(idPosts);
  }

  Future<void> init(String idPosts) async {
    isLoading.value = true;
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
    getMyStore();
    await getPostById(idPosts);
    isLoading.value = false;
  }

  Future<void> getMyStore() async {
    isLoading.value = true;
    try {
      final response = await apiService.getData('stores/user/${user!.idUser}',
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

  Future<void> getPostById(String idPosts) async {
    isLoading.value = true;
    try {
      final response = await apiService.getData('posts/$idPosts',
          accessToken: auth!.metadata);

      if (response['success']) {
        posts = PostModel.fromJson(response['posts'], user!.idUser);
        captionController.text = posts!.caption;

        // Phân loại ảnh từ backend
        listRemotePictures.assignAll(posts!.picture); // Thêm URL vào listRemotePictures
        updateCombinedPictures(); // Cập nhật combinedPictures
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching post: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }


Future<void> updatePosts(String idPosts) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      isLoading.value = true;

      try {

        // Chuẩn bị danh sách file từ thiết bị
        final List<File> pictureFiles = List<File>.from(listLocalPictures);
        String? pictureString = listRemotePictures.isNotEmpty ? listRemotePictures.join(',') : null;

        final response = await apiService.postMultipartData(
          'posts/$idPosts',
          {
          'caption': captionController.text,
          'picture': pictureString ?? '', 
          }, 
          {}, 
          {'picture': pictureFiles}, 
          accessToken: auth?.metadata,
        );

        if (response['success']) {
          Get.back(result: true);
          Get.snackbar("Thành công", "Cập nhật bài viết thành công");
        } else {
          throw Exception(response['message'] ?? "Cập nhật thất bại");
        }
      } catch (e) {
        print("Error updating post: $e");
        Get.snackbar("Lỗi", "Có lỗi xảy ra: ${e.toString()}");
      } finally {
        isLoading.value = false;
      }
    }
  }


void updateCombinedPictures() {
    combinedPictures.assignAll([...listRemotePictures, ...listLocalPictures]);
  }


  void removeImage(dynamic image) {
    if (image is String) {
      listRemotePictures.remove(image);
    } else if (image is File) {
      listLocalPictures.remove(image);
    }
    updateCombinedPictures(); 
  }


  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    
    listLocalPictures.addAll(pickedImages.map((image) => File(image.path)).toList());
    updateCombinedPictures(); 
  }


  bool check_list_empty() {
    return listPicture.isEmpty;
  }
}
