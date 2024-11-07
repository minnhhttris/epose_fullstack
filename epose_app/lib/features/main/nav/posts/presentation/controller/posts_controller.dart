import 'package:get/get.dart';

import '../../../../../../api.config.dart';
import '../../../../../../core/services/api.service.dart';
import '../../../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../../../core/services/model/posts_model.dart';
import '../../../../../../core/services/user/model/auth_model.dart';
import '../../../../../../core/services/user/model/user_model.dart';

class PostsController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getAllPostsEndpoint = 'posts/';

  final GetuserUseCase _getuserUseCase;
  PostsController(this._getuserUseCase);

  UserModel? user;
  AuthenticationModel? auth;
  List<PostModel> listPosts = [];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    init();
    getAllPosts();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
  }

  // get all posts
  Future<void> getAllPosts() async {
    isLoading.value = true;
    try {
      final response = await apiService.getData(getAllPostsEndpoint);
      if (response['success'] == true) {
        String currentUserId = user!.idUser;

        listPosts = List<PostModel>.from(response['posts'].map(
          (x) => PostModel.fromJson(x, currentUserId),
        ));

        listPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        update();
      } else {
        Get.snackbar("Error", "Failed to fetch posts");
      }
    } catch (e) {
      Get.snackbar(
          "Error", "An error occurred while fetching posts: ${e.toString()}");
    } finally {
      isLoading.value = false; 
    }
  }

  var isExpanded = false.obs;
  var isFavorited = false.obs;
  var favoriteCount = 0.obs;

  void initPost(PostModel post) {
    isFavorited.value = post.isFavoritedByUser;
    favoriteCount.value = post.favorites.length;
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
        print("Favorite success");
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
      } else {
        Get.snackbar("Error", "Error unfavoriting post");
      }
    } catch (e) {
      Get.snackbar("Error", "Error unfavoriting post: ${e.toString()}");
    } 
  }

}
