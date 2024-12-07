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

  Future<void> createClothes(String storeId) async {
    if (!validateForm()) return;

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
        "itemSizes": jsonEncode(itemSizes), 
      };

      final List<File> pictureFiles = List<File>.from(listPictureClothes);
      // Gửi dữ liệu cùng với danh sách ảnh
      final response = await apiService.postMultipartData(
        'clothes/store/$storeId/createClothes',
        data, {},
        {
          'listPicture': pictureFiles, 
        },
        accessToken: auth!.metadata,
      );
      if (response['success']) {
        clearForm();
        Get.snackbar("Success", "Quần áo đã được tạo thành công");
      }
    } catch (e) {
      print("Error creating clothes: $e");
      Get.snackbar("Error", "Error creating clothes: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    nameItemController.clear();
    descriptionController.clear();
    priceController.clear();
    colorController.value = '';
    styleController.value = '';
    genderController.value = '';
    listPictureClothes.clear();
    itemSizes.clear();
  }

  bool validateForm() {
    if (nameItemController.text.trim().isEmpty ||
        nameItemController.text.trim().length < 10) {
      Get.snackbar("Lỗi", "Tên sản phẩm phải có ý nghĩa và ít nhất 10 ký tự");
      return false;
    }

    if (priceController.text.trim().isEmpty ||
        double.tryParse(priceController.text.trim()) == null) {
      Get.snackbar("Lỗi", "Giá thuê phải là số hợp lệ và không được để trống");
      return false;
    }

    if (double.tryParse(priceController.text.trim())! <= 10000) {
      Get.snackbar("Lỗi", "Giá thuê phải lớn hơn 10000");
      return false;
    }

    if (listPictureClothes.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng thêm ít nhất một hình ảnh sản phẩm");
      return false;
    }

    if (descriptionController.text.trim().isEmpty ||
        descriptionController.text.trim().length < 20) {
      Get.snackbar("Lỗi", "Mô tả sản phẩm phải có ý nghĩa và ít nhất 20 ký tự");
      return false;
    }

    if (colorController.value.trim().isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng chọn màu sắc sản phẩm");
      return false;
    }

    if (styleController.value.trim().isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng chọn kiểu dáng sản phẩm");
      return false;
    }

    if (genderController.value.trim().isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng chọn giới tính phù hợp");
      return false;
    }

    if (itemSizes.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng thêm ít nhất một kích cỡ và số lượng");
      return false;
    }

    for (var item in itemSizes) {
      if (int.tryParse(item['quantity'].toString()) == null ||
          item['quantity'] <= 0) {
        Get.snackbar(
            "Lỗi", "Số lượng cho mỗi kích cỡ phải là số hợp lệ và lớn hơn 0");
        return false;
      }
    }

    return true;
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
    if (size.trim().isEmpty || quantity.trim().isEmpty) {
      Get.snackbar("Lỗi", "Kích thước và số lượng không được để trống");
      return;
    }

    if (int.tryParse(quantity.trim()) == null ||
        int.parse(quantity.trim()) <= 0) {
      Get.snackbar("Lỗi", "Số lượng phải là số hợp lệ và lớn hơn 0");
      return;
    }
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
