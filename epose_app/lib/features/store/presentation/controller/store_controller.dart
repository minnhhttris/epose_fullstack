import 'package:epose_app/core/services/model/store_model.dart';
import 'package:epose_app/core/services/user/model/auth_model.dart';
import 'package:get/get.dart';

import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/clothes_model.dart';
import '../../../../core/services/model/posts_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/user_model.dart';

class StoreController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getStoreUserEndpoint = 'stores/getStore';
  final GetuserUseCase _getuserUseCase;
  StoreController(this._getuserUseCase);

  UserModel? user;
  StoreModel? store;
  AuthenticationModel? auth;
  List<ClothesModel> listClothesOfStore = [];
  List<PostModel> listPostsOfStore = [];

  var isLoading = false.obs;
  var isLoadingClothes = false.obs;
  var isLoadingPosts = false.obs;

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
        if (store != null) {
          getClothesOfStore(store!.idStore);
          getPostsOfStore(store!.idStore);
          update();
        }
      }
    } catch (e) {
      print("Error fetching store: $e", );
      Get.snackbar("Error", "Error fetching store: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getClothesOfStore(String storeId) async {
    isLoadingClothes.value = true;
    try {
      final response = await apiService.getData('clothes/store/$storeId',
          accessToken: auth!.metadata);
      if (response['success']) {
        listClothesOfStore = List<ClothesModel>.from(
          response['data'].map((x) => ClothesModel.fromJson(x)),
        );
        update();
      }
    } catch (e) {
      print(
        "Error fetching clothes: $e",
      );
      Get.snackbar("Error", "Error fetching clothes: ${e.toString()}");
    } finally {
      isLoadingClothes.value = false;
    }
  }

  Future<void> getPostsOfStore(String storeId) async {
    isLoadingPosts.value = true;
    try {
      final response = await apiService.getData('posts/store/$storeId',
          accessToken: auth!.metadata);
      if (response['success']) {
        listPostsOfStore = List<PostModel>.from(
          response['posts'].map(
            (x) => PostModel.fromJson(x, user!.idUser),
          ),
        );
        update();
      }
    } catch (e) {
      print("Error fetching posts: $e", );
      Get.snackbar("Error", "Error fetching clothes: ${e.toString()}");
    } finally {
      isLoadingPosts.value = false;
    }
  }

  var isExpanded = false.obs;
  var isFavorited = false.obs;
  var favoriteCount = 0.obs;

  void initPost(PostModel post) {
    isFavorited.value = post.isFavoritedByUser;
    favoriteCount.value = post.favorites.length;
  }

  void toggleFavorite(PostModel post) async {
    if (isFavorited.value) {
      await unfavoritePost(post.idPosts);
      isFavorited.value = false;
      favoriteCount.value--;
    } else {
      await favoritePost(post.idPosts);
      isFavorited.value = true;
      favoriteCount.value++;
    }
  }

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
