import 'package:get/get.dart';
import '../../../../api.config.dart';
import '../../../../core/configs/enum.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/bagShopping_model.dart';
import '../../../../core/services/model/clothes_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';
import '../../../../core/ui/dialogs/dialogs.dart';

class BagShoppingController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getUserBagShoppingEndpoint = 'bagShopping/';

  final GetuserUseCase _getuserUseCase;
  BagShoppingController(this._getuserUseCase);

  UserModel? user;
  AuthenticationModel? auth;
  BagShoppingModel? bagShopping;

  var isLoading = false.obs;

  var shoppingBag = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
    await getBagShopping();
  }

  // Lấy giỏ hàng từ API
  Future<void> getBagShopping() async {
    try {
      final response = await apiService.getData(
        getUserBagShoppingEndpoint,
        accessToken: auth?.metadata,
      );
      if (response['success']) {
        bagShopping = BagShoppingModel.fromJson(response['data']);
        _updateShoppingBag();
        update();
      }
    } catch (e) {
      print(e);
      //Get.snackbar("Error", "Failed to fetch bag shopping: ${e.toString()}");
    }
  }

  Future<void> addItemToBag(
      String idStore, String idItem, String size, int quantity) async {
    final endpoint = 'bagShopping/$idStore/$idItem';
    try {
      await apiService.postData(endpoint, {
        'size': size,
        'quantity': quantity,
      });
      await getBagShopping();
    } catch (e) {
      print('Failed to add item to bag: $e');
    }
  }

  // Cập nhật danh sách giỏ hàng từ dữ liệu nhận được
  void _updateShoppingBag() {
    shoppingBag.clear();
    if (bagShopping != null) {
      // Nhóm sản phẩm theo cửa hàng
      var groupedByStore = <String, List<BagItemModel>>{};
      for (var item in bagShopping!.items) {
        groupedByStore[item.store.idStore] ??= [];
        groupedByStore[item.store.idStore]!.add(item);
      }

      // Tạo danh sách giỏ hàng hiển thị
      shoppingBag.addAll(groupedByStore.entries.map((entry) {
        return {
          "storeName": entry.value.first.store.nameStore,
          "products": entry.value,
        };
      }).toList());
    }
  }

  // Cập nhật số lượng sản phẩm
  Future<void> updateQuantity(String idItem, String size, int quantity) async {
    try {
      // Lấy thông tin sản phẩm từ API
      final response = await apiService.getData(
        'clothes/$idItem',
        accessToken: auth?.metadata,
      );

      if (response['success']) {
        final clothes = ClothesModel.fromJson(response['data']);
        final itemSize = clothes.itemSizes.firstWhere(
          (s) => s.size.toString().split('.').last == size,
          orElse: () => throw Exception("Kích cỡ không tồn tại"),
        );

        // Kiểm tra số lượng
        if (quantity > itemSize.quantity) {
          Get.snackbar(
            "Thông báo",
            "Số lượng yêu cầu vượt quá số lượng tồn kho (${itemSize.quantity})",
          );
          return;
        }

        // Gửi yêu cầu cập nhật số lượng
        await apiService.postData(
          'bagShopping/$idItem',
          {'quantity': quantity},
          accessToken: auth?.metadata,
        );

        // Tải lại giỏ hàng
        await getBagShopping();
      }
    } catch (e) {
      Get.snackbar("Error", "Không thể cập nhật số lượng: ${e.toString()}");
    }
  }


  //dialog xác nhận xóa sản phẩm khỏi giỏ hàng
  void confirmRemoveItem(String idItem, String size) {
    DialogsUtils.showAlertDialog(
      title: "Xóa sản phẩm",
      message: "Bạn muốn xóa trang phục này khỏi giỏ hàng?",
      typeDialog: TypeDialog.warning,
      onPresss: () => (removeItemBag(idItem, size)),
    );
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeItemBag(String idItem, String size) async {
    isLoading(true);
    try {
      final response = await apiService.deleteData('bagShopping/$idItem',
          data: {'size': size}, accessToken: auth?.metadata);
      if (response['success']) {
        Get.snackbar("Success", "Đã xóa sản phẩm khỏi giỏ hàng");
        await getBagShopping();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to remove item from bag: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  double get totalAmount {
    double total = 0.0;
    for (var store in shoppingBag) {
      for (var product in store['products']) {
        BagItemModel bagItem = product as BagItemModel;
        if (bagItem.isSelected) {
          double price = bagItem.clothes.price;
          total += price * bagItem.quantity;
        }
      }
    }
    return total;
  }

  // Hàm tăng số lượng sản phẩm
  void incrementQuantity(int storeIndex, int productIndex) async {
  var store = shoppingBag[storeIndex];
  var products = store['products'] as List<BagItemModel>;
  var product = products[productIndex];

  try {
    // Lấy thông tin sản phẩm từ API
    final response = await apiService.getData(
      'clothes/${product.idItem}',
      accessToken: auth?.metadata,
    );

    if (response['success']) {
      final clothes = ClothesModel.fromJson(response['data']);
      final itemSize = clothes.itemSizes.firstWhere(
        (s) => s.size.toString().split('.').last == product.size,
        orElse: () => throw Exception("Kích cỡ không tồn tại"),
      );

      // Kiểm tra số lượng
      if (product.quantity + 1 > itemSize.quantity) {
        var sizeName = product.size.split('.').last;
        Get.snackbar(
          "Thông báo",
          "Không thể tăng, tồn kho size ${sizeName} chỉ còn ${itemSize.quantity}",
        );
        return;
      }

      // Tăng số lượng
      product.quantity++;
      await updateQuantity(product.idItem, product.size, product.quantity);
      update();
    }
  } catch (e) {
    print("Failed to increment quantity: $e");
  }
}


  void decrementQuantity(int storeIndex, int productIndex) async {
    var store = shoppingBag[storeIndex];
    var products = store['products'] as List<BagItemModel>;
    var product = products[productIndex];

    // Đảm bảo số lượng không giảm xuống dưới 1
    if (product.quantity > 1) {
      try {
        // Lấy thông tin sản phẩm từ API
        final response = await apiService.getData(
          'clothes/${product.idItem}',
          accessToken: auth?.metadata,
        );

        if (response['success']) {
          final clothes = ClothesModel.fromJson(response['data']);
          final itemSize = clothes.itemSizes.firstWhere(
            (s) => s.size.toString().split('.').last == product.size,
            orElse: () => throw Exception("Kích cỡ không tồn tại"),
          );

          // Kiểm tra số lượng tồn kho
          if (product.quantity - 1 <= itemSize.quantity) {
            // Giảm số lượng nếu hợp lệ
            product.quantity--;
            await updateQuantity(
                product.idItem, product.size, product.quantity);
            update();
          }
        }
      } catch (e) {
        print("Failed to decrement quantity: $e");
      }
    }
  }

  // Thay đổi trạng thái chọn của sản phẩm
  void toggleSelection(int storeIndex, int productIndex) {
    var store = shoppingBag[storeIndex];
    var products = store['products'] as List<BagItemModel>;
    var product = products[productIndex];
    product.isSelected = !product.isSelected;
    shoppingBag.refresh();
    update();
  }
}
