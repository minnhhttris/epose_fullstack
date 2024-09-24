import 'package:get/get.dart';

class ClothesController extends GetxController {
  // Danh sách các sản phẩm tạm thời
  var clothesList = <Map<String, String>>[
    {
      "imageUrl": "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg",
      "storeName": "Store ABCD",
      "price": "180,000 vnd",
      "productName": "Áo dài đỏ tết",
      "tags": "đỏ, áo dài",
    },
    {
      "imageUrl": "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg",
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

    // Biến trạng thái của menu lọc
  var isFilterMenuOpen = false.obs;

  // Hàm để mở và đóng menu lọc
  void toggleFilterMenu() {
    isFilterMenuOpen.value = !isFilterMenuOpen.value;
  }

  // Hàm để thiết lập lại bộ lọc
  void resetFilters() {
    // Thực hiện thiết lập lại bộ lọc
  }

  // Hàm để áp dụng bộ lọc
  void applyFilters() {
    // Thực hiện áp dụng bộ lọc
  }
}
