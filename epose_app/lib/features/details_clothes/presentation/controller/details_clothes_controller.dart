import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../api.config.dart';
import '../../../../core/configs/enum.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/clothes_model.dart';
import '../../../../core/services/model/store_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';
import '../../../../core/ui/dialogs/dialogs.dart';

class DetailsClothesController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getStoreUserEndpoint = 'stores/getStore';
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
  StoreModel? store;

  @override
  void onInit() {
    super.onInit();
    init();
    getClothesById(idItem);
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
    getMyStore();
  }

  Future<void> getClothesById(String idItem) async {
    isLoading.value = true;

    final response = await apiService.getData('clothes/$idItem');

    if (response['success'] == true) {
      clothes = ClothesModel.fromJson(
        response['data'],
      );
    } else {
      Get.snackbar("Error", "Failed to fetch clothes");
    }

    isLoading.value = false;
    update();
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
      print(e);
      //Get.snackbar("Error", "Error fetching store: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void showDeleteClothesDialog() {
    DialogsUtils.showAlertDialog(
      title: "Delete post",
      message: "Bạn có thật sự muốn xóa trang phục này?",
      typeDialog: TypeDialog.warning,
      onPresss: () => (deleteClothes(clothes!.idItem)),
    );
  }

  Future<void> deleteClothes(String idItem) async {
    isLoading.value = true;

    final response = await apiService.deleteData('clothes/$idItem',
        accessToken: auth!.metadata);

    if (response['success'] == true) {
      Get.back();
      Get.snackbar("Success", "Clothes deleted successfully");
    } else {
      Get.snackbar("Error", "Failed to delete clothes");
    }

    isLoading.value = false;
  }

  String convertSizeEnumString(String sizeEnumString) {
    return sizeEnumString.split('.').last;
  }

  Future<void> addItemToBag(
      String idStore, String idItem, String size, int quantity) async {
    try {

      if (store != null && store!.idStore == idStore) {
        Get.snackbar(
          "Lỗi",
          "Không thể thêm sản phẩm từ cửa hàng của bạn vào giỏ hàng",
        );
        return; 
      } 

      final convertedSize = convertSizeEnumString(size);

      final response = await apiService.postData(
          'bagShopping/$idStore/$idItem',
          {
            'size': convertedSize,
            'quantity': quantity,
          },
          accessToken: auth!.metadata);
      if (response['success'] == true) {
        Get.snackbar("Success", "Đã thêm vào giỏ hàng");
      } else {
        Get.snackbar("Error", "Failed to add item to bag");
      }
    } catch (e) {
      print('Failed to add item to bag: $e');
      Get.snackbar("Error", "Failed to add item to bag: ${e.toString()}");
    }
  }

}


