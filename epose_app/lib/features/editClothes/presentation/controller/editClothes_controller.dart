import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/clothes_model.dart';
import '../../../../core/services/model/store_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class EditClothesController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;
  EditClothesController(this._getuserUseCase);

  UserModel? user;
  AuthenticationModel? auth;
  ClothesModel? clothes;
  StoreModel? store;

  late final String idItem;

  var isLoading = false.obs;

  final formKey = GlobalKey<FormState>();
  final nameItemController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  var colorController = ''.obs;
  var styleController = ''.obs;
  var genderController = ''.obs;

  var itemSizes = <Map<String, dynamic>>[].obs;
  var combinedPictures = <dynamic>[].obs;
  final listPictureClothes = <File>[].obs;
  final listRemotePictures = <String>[].obs;
  final listLocalPictures = <File>[].obs;

  var selectedSize = ''.obs;
  var selectedQuantity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    init();
    final args = Get.arguments as Map<String, dynamic>;
    idItem = args['idItem'];
    getClothesById(idItem);
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
  }

  Future<void> getClothesById(String idItem) async {
    isLoading.value = true;

    final response = await apiService.getData('clothes/$idItem');

    if (response['success'] == true) {
      clothes = ClothesModel.fromJson(response['data']);

      nameItemController.text = clothes!.nameItem;
      priceController.text = clothes!.price.toString().split('.').first;
      descriptionController.text = clothes!.description;
      colorController.value = clothes?.color.toString().split('.').last ?? '';
      styleController.value = clothes?.style.toString().split('.').last ?? '';
      genderController.value = clothes?.gender.toString().split('.').last ?? '';
      itemSizes.value = clothes!.itemSizes.map((size) {
        return {
          'size': size.size.toString().split('.').last,
          'quantity': size.quantity
        } as Map<String, dynamic>; 
      }).toList();
      listRemotePictures.assignAll(clothes!.listPicture);
      updateCombinedPictures();

    } else {
      Get.snackbar("Error", "Failed to fetch clothes");
    }

    isLoading.value = false;
    update();
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

    if (combinedPictures.isEmpty) {
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

  Future<void> updateClothes(String idItem) async {
    if (!validateForm()) return;

    isLoading.value = true;
    try {

      final List<File> pictureFiles = List<File>.from(listLocalPictures);
      String? pictureString = listRemotePictures.isNotEmpty ? listRemotePictures.join(',') : null;

      final response = await apiService.postMultipartData(
        'clothes/$idItem',
        {
          "nameItem": nameItemController.text,
          "description": descriptionController.text,
          "price": priceController.text,
          "color": colorController.value,
          "style": styleController.value,
          "gender": genderController.value,
          "itemSizes": jsonEncode(itemSizes),
          "listPicture": pictureString ?? '',
        },
        {},
        {
          'listPicture': pictureFiles,
        },
        accessToken: auth!.metadata,
      );
      if (response['success']) {
        Get.snackbar("Success", "Quần áo đã được cập nhật thành công");
      }
    } catch (e) {
      print("Error update clothes: $e");
      Get.snackbar("Lỗi", "Có lỗi xảy ra: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedColor(String color) {
    colorController.value = color;
  }

  void setSelectedStyle(String style) {
    styleController.value = style;
  }

  void setSelectedGender(String gender) {
    genderController.value = gender;
  }

  void setSelectedSize(String size) {
    selectedSize.value = size;
  }

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

  // void addSize(String size, String quantity) {
  //   // Kiểm tra xem kích thước và số lượng có trống không
  //   if (size.trim().isEmpty || quantity.trim().isEmpty) {
  //     Get.snackbar("Lỗi", "Kích thước và số lượng không được để trống");
  //     return;
  //   }

  //   // Kiểm tra xem số lượng có phải là số hợp lệ và lớn hơn 0 không
  //   if (int.tryParse(quantity.trim()) == null ||
  //       int.parse(quantity.trim()) <= 0) {
  //     Get.snackbar("Lỗi", "Số lượng phải là số hợp lệ và lớn hơn 0");
  //     return;
  //   }

  //   // Kiểm tra xem kích thước đã tồn tại trong danh sách chưa
  //   bool sizeExists = itemSizes.any((element) => element["size"] == size);

  //   // Nếu kích thước đã tồn tại, thông báo lỗi
  //   if (sizeExists) {
  //     Get.snackbar("Lỗi", "Kích thước này đã tồn tại");
  //   } else {
  //     // Nếu kích thước chưa tồn tại, thêm vào danh sách
  //     itemSizes.add({
  //       "size": size, // Kích thước (String)
  //       "quantity": int.parse(quantity), // Số lượng (int)
  //     });

  //     // Hiển thị thông báo thành công
  //     Get.snackbar("Thành công", "Kích thước đã được thêm");
  //   }
  // }

  void updateSize(int index, String newQuantity) {
    final quantity = int.tryParse(newQuantity);
    if (quantity == null || quantity < 0) {
      Get.snackbar("Error", "Số lượng phải là số hợp lệ và không âm");
      return;
    }
    itemSizes[index]['quantity'] = quantity;
    itemSizes.refresh(); // Cập nhật lại danh sách
  }

  bool check_list_empty() {
    return listPictureClothes.isEmpty;
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

    if (pickedImages != null) {
      listLocalPictures
          .addAll(pickedImages.map((image) => File(image.path)).toList());
      updateCombinedPictures();
    }
  }
}
