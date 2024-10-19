import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/clothes_model.dart';
import '../../../../core/services/model/store_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class CreateClothesController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getStoreUserEndpoint = 'stores/getStore';
  final GetuserUseCase _getuserUseCase;

  CreateClothesController(this._getuserUseCase);

  UserModel? user;
  StoreModel? store;
  AuthenticationModel? auth;
  ClothesModel? clothes;

  var isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final nameItemController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final listPictureClothes = <File>[].obs;
  var colorController = ''.obs;
  var styleController = ''.obs;
  var genderController = ''.obs;

  var itemSizes = <Map<String, dynamic>>[].obs;

  var selectedSize = ''.obs;
  var selectedQuantity = ''.obs;


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

  // Future<void> createClothes(String storeId) async {
  //   isLoading.value = true;
  //   try {
  //     final data = {
  //       "nameItem": nameItemController.text,
  //       "description": descriptionController.text,
  //       "price": priceController.text,
  //       "listPicture": listPictureClothes,
  //       "color": colorController.value,
  //       "style": styleController.value,
  //       "gender": genderController.value,
  //       "itemSizes": itemSizes,
  //     };

  //     final response = await apiService.postData(
  //         'clothes/store/$storeId/createClothes', data,
  //         accessToken: auth!.metadata);
  //     if (response['success']) {
  //       clothes = ClothesModel.fromJson(response['data']);
  //       Get.snackbar("Success", "Quần áo đã được tạo thành công");
  //     }
  //   } catch (e) {
  //     print("Error creating clothes: $e");
  //     Get.snackbar("Error", "Error creating clothes: ${e.toString()}");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> createClothes(String storeId) async {
    isLoading.value = true;
    try {
      // Dữ liệu text (fields)
      final data = {
        "nameItem": nameItemController.text,
        "description": descriptionController.text,
        "price": priceController.text,
        "color": colorController.value,
        "style": styleController.value,
        "gender": genderController.value,
        "itemSizes": jsonEncode(itemSizes), // Chuyển itemSizes thành chuỗi JSON
      };

      // Gửi dữ liệu cùng với danh sách ảnh
      final response = await apiService.postMultipartData(
        'clothes/store/$storeId/createClothes',
        data,
        listPictureClothes,
        accessToken: auth!.metadata,
      );
      print("Response: $response");
      if (response['success']) {
        clothes = ClothesModel.fromJson(response['data']);
        Get.snackbar("Success", "Quần áo đã được tạo thành công");
      }
    } catch (e) {
      print("Error creating clothes: $e");
      Get.snackbar("Error", "Error creating clothes: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }



  // Function to set the selected color from the modal
  void setSelectedColor(String color) {
    colorController.value = color;
  }

  // Function to set the selected style from the modal
  void setSelectedStyle(String style) {
    styleController.value = style;
  }

  // Function to set the selected gender from the modal
  void setSelectedGender(String gender) {
    genderController.value = gender;
  }

  // Function to set the selected size from the modal
  void setSelectedSize(String size) {
    selectedSize.value = size;
  }

  // Function to set the selected quantity from input
  void setSelectedQuantity(String quantity) {
    selectedQuantity.value = quantity;
  }

  void addSize(String size, String quantity) {
    // Kiểm tra xem kích thước đã tồn tại hay chưa
    bool sizeExists = itemSizes.any((element) => element["size"] == size);

    if (sizeExists) {
      Get.snackbar("Lỗi", "Kích thước này đã tồn tại");
    } else {
      itemSizes.add({"size": size, "quantity": int.parse(quantity)});
      Get.snackbar("Thành công", "Kích thước đã được thêm");
    }
  }

  //PictureClothes
  void removeImage(File image) {
    listPictureClothes.remove(image);
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    listPictureClothes
        .addAll(pickedImages.map((image) => File(image.path)).toList());
  }

  bool check_list_empty() {
    return listPictureClothes.isEmpty;
  }

}
