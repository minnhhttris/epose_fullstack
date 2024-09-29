import 'package:epose_app/core/configs/app_images_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  var currentIndex = 0.obs;

  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  var showAllCategories = false.obs;

  void toggleShowAll() {
    showAllCategories.value = !showAllCategories.value;
  }

  List<Map<String, String?>> get visibleCategories {
    if (showAllCategories.value) {
      return categories;
    } else {
      return categories.sublist(0, 7) +
          [
            {'name': 'Khác', 'icon': AppImagesString.eKhac}
          ];
    }
  }

  // List các hạng mục trang phục, gán giá trị demo
  final categories = [
    {'name': 'Áo dài', 'icon': AppImagesString.eAoDai},
    {'name': 'Tứ thân', 'icon': AppImagesString.eTuThan},
    {'name': 'Cổ phục', 'icon': AppImagesString.eCoPhuc},
    {'name': 'Áo bà ba', 'icon': AppImagesString.eAoBaBa},
    {'name': 'Dạ hội', 'icon': AppImagesString.eDaHoi},
    {'name': 'Nàng thơ', 'icon': AppImagesString.eNangTho},
    {'name': 'Học đường', 'icon': AppImagesString.eHocDuong},
    {'name': 'Vintage', 'icon': AppImagesString.eVintage},
    {'name': 'Cá tính', 'icon': AppImagesString.eCaTinh},  
    {'name': 'Sexy', 'icon': AppImagesString.eSexy},
    {'name': 'Công sở', 'icon': AppImagesString.eCongSo},
    {'name': 'Dân tộc', 'icon': AppImagesString.eDanToc},
    {'name': 'Đồ đôi', 'icon': AppImagesString.eDoDoi},
    {'name': 'Hóa trang', 'icon': AppImagesString.eHoaTrang},
    {'name': 'Các nước', 'icon': AppImagesString.eCacNuoc},
    {'name': 'Khác', 'icon': AppImagesString.eKhac},
  ].obs; 

   ScrollController scrollController = ScrollController();
  // List các cửa hàng tiêu biểu, gán giá trị demo
   List<Map<String, String>> topStores = [
    {"name": "Store ABC", "icon": AppImagesString.eAvatarStoreDefault},
    {"name": "Store XYZ", "icon": AppImagesString.eAvatarStoreDefault},
    {"name": "Store 123", "icon": AppImagesString.eAvatarStoreDefault},
    {"name": "Store 456", "icon": AppImagesString.eAvatarStoreDefault},
    {"name": "Store 456", "icon": AppImagesString.eAvatarStoreDefault},
    {"name": "Store 456", "icon": AppImagesString.eAvatarStoreDefault},
  ];

  // List sản phẩm gần đây, gán giá trị demo
  var recentPostsList = <Map<String, String>>[
    {
      "imageUrl":
          "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg",
      "storeName": "Store ABCD",
      "price": "180,000 vnd",
      "productName": "Áo dài đỏ tết",
      "tags": "đỏ, áo dài",
    },
    {
      "imageUrl":
          "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg",
      "storeName": "Store ABCD",
      "price": "200,000 vnd",
      "productName": "Áo dài xanh tết",
      "tags": "xanh, áo dài",
    },
    {
      "imageUrl":
          "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg",
      "storeName": "Store ABCD",
      "price": "200,000 vnd",
      "productName": "Áo dài xanh tết",
      "tags": "xanh, áo dài",
    },
    {
      "imageUrl":
          "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg",
      "storeName": "Store ABCD",
      "price": "200,000 vnd",
      "productName": "Áo dài xanh tết",
      "tags": "xanh, áo dài",
    },
    {
      "imageUrl":
          "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg",
      "storeName": "Store ABCD",
      "price": "200,000 vnd",
      "productName": "Áo dài xanh tết",
      "tags": "xanh, áo dài",
    },
    // Thêm nhiều sản phẩm khác
  ].obs;
}
