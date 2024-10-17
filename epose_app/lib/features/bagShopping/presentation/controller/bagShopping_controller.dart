import 'package:get/get.dart';

import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/user_model.dart';

class BagShoppingController extends GetxController {
  final GetuserUseCase _getuserUseCase;
  BagShoppingController(this._getuserUseCase);

  UserModel? user;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
  }
  // Danh sách các sản phẩm trong giỏ hàng với kiểu xác định rõ ràng
  var shoppingBag = <Map<String, dynamic>>[
    {
      "storeName": "Store ABC",
      "products": [
        {
          "imageUrl":
              "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg",
          "productName": "Áo dài đỏ Tết",
          "size": "M",
          "price": "180,000 đ",
          "quantity": 1,
          "isSelected": false, // Trạng thái chọn
        },
        {
          "imageUrl":
              "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg",
          "productName": "Áo dài đỏ Tết",
          "size": "M",
          "price": "180,000 đ",
          "quantity": 1,
          "isSelected": false,
        }
      ]
    },
    {
      "storeName": "Store XYZ",
      "products": [
        {
          "imageUrl":
              "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg",
          "productName": "Áo dài xanh Tết",
          "size": "M",
          "price": "180,000 đ",
          "quantity": 1,
          "isSelected": false,
        }
      ]
    }
  ].obs;

  // Tính tổng giá tiền của các sản phẩm đã chọn
  double get totalAmount {
    double total = 0.0;
    for (var store in shoppingBag) {
      for (var product in store['products']) {
        if (product['isSelected']) {
          double price =
              double.parse(product['price'].replaceAll(RegExp('[^0-9]'), ''));
          total += price * product['quantity'];
        }
      }
    }
    return total;
  }

  // Hàm tăng số lượng sản phẩm
  void incrementQuantity(int storeIndex, int productIndex) {
    var store = shoppingBag[storeIndex];
    var products = store['products'] as List<dynamic>?;
    if (products != null && products[productIndex] != null) {
      var product = products[productIndex] as Map<String, dynamic>;
      product['quantity']++;
      update(); // Cập nhật trạng thái
    }
  }

  // Hàm giảm số lượng sản phẩm
  void decrementQuantity(int storeIndex, int productIndex) {
    var store = shoppingBag[storeIndex];
    var products = store['products'] as List<dynamic>?;
    if (products != null && products[productIndex] != null) {
      var product = products[productIndex] as Map<String, dynamic>;
      if (product['quantity'] > 1) {
        product['quantity']--;
        update(); // Cập nhật trạng thái
      }
    }
  }

  // Hàm thay đổi trạng thái chọn của sản phẩm
  void toggleSelection(int storeIndex, int productIndex) {
    var store = shoppingBag[storeIndex];
    var products = store['products'] as List<dynamic>?;
    if (products != null && products[productIndex] != null) {
      var product = products[productIndex] as Map<String, dynamic>;
      product['isSelected'] = !product['isSelected'];
      update(); 
    }
  }
}
