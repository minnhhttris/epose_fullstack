import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../api.config.dart';
import '../../../../core/configs/enum.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/posts_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';
import '../../../../core/ui/dialogs/dialogs.dart';

class DetailsPostsController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;
  DetailsPostsController(this._getuserUseCase);

  final String postId = Get.arguments;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  var isLoading = false.obs;

  var isExpanded = false.obs;
  var isFavorited = false.obs;
  var favoriteCount = 0.obs;
  var currentImageIndex = 0.obs;

  final TextEditingController commentController = TextEditingController();

  UserModel? user;
  AuthenticationModel? auth;
  PostModel? post;

  @override
  void onInit() {
    super.onInit();
    init();
    getPostById(postId);
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
  }

  Future<void> getPostById(String postId) async {
    isLoading.value = true;

    final response = await apiService.getData('posts/$postId');

    if (response['success'] == true) {
      post = PostModel.fromJson(response['posts'], user!.idUser);
      isFavorited.value = post!.isFavoritedByUser;
      favoriteCount.value = post!.favorites.length;
      
    } else {
      Get.snackbar("Error", "Failed to fetch post");
    }

    isLoading.value = false;
    update();
  }

  // Phương thức gọi API yêu thích bài viết
  Future<void> favoritePost(String postId) async {
    if (auth == null) {
      Get.snackbar("Error", "User is not authenticated.");
      return;
    }
    try {
      final response = await apiService.postData(
        'posts/$postId/favorite',
        {},
        accessToken: auth!.metadata,
      );

      if (response['success'] == true) {
        return;
      } else {
        Get.snackbar("Error", "Error favoriting post");
      }
    } catch (e) {
      Get.snackbar("Error", "Error favoriting post: ${e.toString()}");
    }
  }

  Future<void> unfavoritePost(String postId) async {
    if (auth == null) {
      Get.snackbar("Error", "User is not authenticated.");
      return;
    }
    try {
      final response = await apiService.postData(
        'posts/$postId/unfavorite',
        {},
        accessToken: auth!.metadata,
      );

      if (response['success'] == true) {
        return;
      } else {
        Get.snackbar("Error", "Error unfavoriting post");
      }
    } catch (e) {
      Get.snackbar("Error", "Error unfavoriting post: ${e.toString()}");
    } finally {}
  }

  Future<void> addComment(String postId, String comment) async {
    if (auth == null) {
      Get.snackbar("Error", "User is not authenticated.");
      return;
    }

    if (commentController.text.trim().isEmpty) {
      DialogsUtils.showAlertDialog2(
        message: "Comment can't be empty",
        typeDialog: TypeDialog.error,
        title: 'Lỗi',
      );
      return;
    }

    const int maxCommentLength = 200;
    if (commentController.text.length > maxCommentLength) {
      DialogsUtils.showAlertDialog2(
        message: "Comment cannot exceed $maxCommentLength characters",
        typeDialog: TypeDialog.error,
        title: 'Lỗi',
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await apiService.postData(
        'comment/$postId',
        {"comment": comment},
        accessToken: auth!.metadata,
      );

      if (response['success'] == true) {
        return;
      } else {
        Get.snackbar("Error", "Error adding comment");
      }
    } catch (e) {
      Get.snackbar("Error", "Error adding comment: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void showDeleteConfirmationDialog(String idComment, String idUser) {
    DialogsUtils.showAlertDialog(
      title: "Delete comment",
      message: "Bạn có thật sự muốn xóa comments này?",
      typeDialog: TypeDialog.warning,
      onPresss: () => (deleteComment(idComment, idUser)),
    );
  }

  void cannotDeleteComment() {
    DialogsUtils.showAlertDialog2(
      message: "You can't delete this comment",
      typeDialog: TypeDialog.error,
      title: 'Lỗi',
    );
  }

  Future<void> deleteComment(String idComment, String idUser) async {
    if (auth == null) {
      Get.snackbar("Error", "User is not authenticated.");
      return;
    }
    isLoading.value = true;
    final response = await apiService.deleteData('comment/$idComment',
        accessToken: auth!.metadata);
    

    if (response['success'] == true) {
      Get.snackbar("Success", "Comment deleted successfully");
    } else {
      Get.snackbar("Error", "Failed to delete comment");
    }
    isLoading.value = false;
    update();
  }

  void toggleFavorite() async {
    if (isFavorited.value) {
      await unfavoritePost(post!.idPosts);
      isFavorited.value = false;
      favoriteCount.value--;
    } else {
      await favoritePost(post!.idPosts);
      isFavorited.value = true;
      favoriteCount.value++;
    }
    update();
  }
}
