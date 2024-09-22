import 'package:epose_app/core/configs/app_images_string.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // List các hạng mục trang phục, gán giá trị demo
  final categories = [
    {'name': 'Áo dài', 'icon': AppImagesString.eClothes},
    {'name': 'Tứ thân', 'icon': AppImagesString.eClothes},
    {'name': 'Cổ phục', 'icon': AppImagesString.eClothes},
    {'name': 'Áo bà ba', 'icon': AppImagesString.eClothes},
    {'name': 'Dạ hội', 'icon': AppImagesString.eClothes},
    {'name': 'Nàng thơ', 'icon': AppImagesString.eClothes},
    {'name': 'Học đường', 'icon': AppImagesString.eClothes},
    {'name': 'Khác', 'icon': AppImagesString.eClothes},
  ].obs; 

  // List các cửa hàng tiêu biểu, gán giá trị demo
  final featuredStores = [
    {'name': 'Store ABC', 'icon': AppImagesString.eAvatarStoreDefault}, 
    {'name': 'Store ABC', 'icon': AppImagesString.eAvatarStoreDefault},
    {'name': 'Store ABC', 'icon': AppImagesString.eAvatarStoreDefault},
    {'name': 'Store ABC', 'icon': AppImagesString.eAvatarStoreDefault},
  ].obs;

  // List sản phẩm gần đây, gán giá trị demo
  final recentProducts = [
    {
      'name': 'Áo dài đỏ tết',
      'price': '180 000 VNĐ',
      'image': AppImagesString.eClothestemp,
      'store': 'Store ABCD'
    },
    {
      'name': 'Áo dài đỏ tết',
      'price': '180 000 VNĐ',
      'image': AppImagesString.eClothestemp,
      'store': 'Store ABCD'
    },
    {
      'name': 'Áo dài đỏ tết',
      'price': '180 000 VNĐ',
      'image': AppImagesString.eClothestemp,
      'store': 'Store ABCD'
    },
    {
      'name': 'Áo dài đỏ tết',
      'price': '180 000 VNĐ',
      'image': AppImagesString.eClothestemp,
      'store': 'Store ABCD'
    },
  ].obs;
}
