import 'package:get/get.dart';
import '../../../../api.config.dart';
import '../../../../core/configs/enum.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/bagShopping_model.dart';
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
        print(bagShopping);
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
  Future<void> updateQuantity(String idItem, int quantity) async {
    final endpoint = 'bagShopping/$idItem';
    try {
      await apiService.postData(
          endpoint,
          {
            'quantity': quantity,
          },
          accessToken: auth?.metadata);
      await getBagShopping();
    } catch (e) {
      Get.snackbar("Error", "Failed to update item quantity: ${e.toString()}");
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
      final response = await apiService.deleteData('bagShopping/$idItem', data:{'size': size}, 
       accessToken: auth?.metadata);
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
 void incrementQuantity(int storeIndex, int productIndex) {
    var store = shoppingBag[storeIndex];
    var products = store['products'] as List<BagItemModel>;
    var product = products[productIndex];
    product.quantity++;
    updateQuantity(product.idItem, product.quantity); 
    update();
  }

  void decrementQuantity(int storeIndex, int productIndex) {
    var store = shoppingBag[storeIndex];
    var products = store['products'] as List<BagItemModel>;
    var product = products[productIndex];
    if (product.quantity > 1) {
      product.quantity--;
      updateQuantity(product.idItem, product.quantity); 
      update();
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
