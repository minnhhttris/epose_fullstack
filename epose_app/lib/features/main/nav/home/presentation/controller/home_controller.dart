import 'package:epose_app/core/configs/app_images_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../api.config.dart';
import '../../../../../../core/configs/enum.dart';
import '../../../../../../core/services/api.service.dart';
import '../../../../../../core/services/model/bagShopping_model.dart';
import '../../../../../../core/services/model/clothes_model.dart';
import '../../../../../../core/services/model/store_model.dart';
import '../../../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../../../core/services/user/model/auth_model.dart';
import '../../../../../../core/services/user/model/user_model.dart';
import '../../../../../../core/ui/dialogs/dialogs.dart';

class HomeController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getAllClothesEndpoint = 'clothes/';
  final String getAllStoreEndpoint = 'stores/';
  final GetuserUseCase _getuserUseCase;

  HomeController(this._getuserUseCase);

  UserModel? user;
  AuthenticationModel? auth;
  StoreModel? store;

  var listClothes = <ClothesModel>[].obs;
  var listStore = <StoreModel>[].obs;
  var isLoading = false.obs;
  var searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    init();
    getTop10RatedClothes();
    getTopStore();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
    getBagShopping();
    getMyStore();
  }

  Future<void> getTop10RatedClothes() async {
    isLoading.value = true;
    try {
      final response = await apiService.getData(getAllClothesEndpoint);
      if (response['success']) {
        // Parse the clothes data
        listClothes.value = List<ClothesModel>.from(
          response['data'].map((x) => ClothesModel.fromJson(x)),
        );

        listClothes.sort((a, b) => b.rate.compareTo(a.rate));

        listClothes.value = listClothes.take(10).toList();
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching clothes: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTopStore() async {
    try {
      final response = await apiService.getData(getAllStoreEndpoint);
      if (response['success']) {
        // Lọc những cửa hàng có trạng thái active
        listStore.value = List<StoreModel>.from(
          response['stores']
              .where((store) => store['status'] == 'active')
              .map((x) => StoreModel.fromJson(x)),
        );

        listStore.sort((a, b) => b.rate.compareTo(a.rate));
        listStore.value = listStore.take(7).toList();
      }
    } catch (e) {
      print("Error fetching stores: $e");
    }
  }

  final String getUserBagShoppingEndpoint = 'bagShopping/';
  BagShoppingModel? bagShopping;
  var isLoadingBag = false.obs;

  Future<void> getBagShopping() async {
    isLoadingBag.value = true; // Bắt đầu tải
    try {
      final response = await apiService.getData(
        getUserBagShoppingEndpoint,
        accessToken: auth?.metadata,
      );
      if (response['success']) {
        bagShopping = BagShoppingModel.fromJson(response['data']);
        print("Bag shopping loaded successfully: ${bagShopping?.items.length}");
        update(); // Thông báo cho giao diện
      } else {
        print("Failed to load bag shopping: ${response['statusCode']}");
      }
    } catch (e) {
      print("Error fetching bag shopping: $e");
    } finally {
      isLoadingBag.value = false; // Kết thúc tải
    }
  }

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

  void showDeleteClothesDialog(String idItem) {
    DialogsUtils.showAlertDialog(
      title: "Delete post",
      message: "Bạn có thật sự muốn xóa trang phục này?",
      typeDialog: TypeDialog.warning,
      onPresss: () => (deleteClothes(idItem)),
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

  Future<void> getMyStore() async {
    isLoading.value = true;
    if (user == null || auth == null) return;
    var userId = user!.idUser;
    try {
      final response = await apiService.getData('stores/user/$userId',
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
  List<Map<String, String>> topStores = [];

  // List sản phẩm gần đây, gán giá trị demo
  var recentPostsList = <Map<String, String>>[].obs;
}

extension ColorExtension on Color {
  String get displayName {
    switch (this) {
      case Color.red:
        return 'Đỏ';
      case Color.blue:
        return 'Xanh dương';
      case Color.green:
        return 'Xanh lá';
      case Color.yellow:
        return 'Vàng';
      case Color.black:
        return 'Đen';
      case Color.white:
        return 'Trắng';
      case Color.pink:
        return 'Hồng';
      case Color.purple:
        return 'Tím';
      case Color.orange:
        return 'Cam';
      case Color.brown:
        return 'Nâu';
      case Color.gray:
        return 'Xám';
      case Color.beige:
        return 'Be';
      case Color.colorfull:
        return 'Đa sắc';
      default:
        return '';
    }
  }
}

// Extension cho enum Style
extension StyleExtension on Style {
  String get displayName {
    switch (this) {
      case Style.ao_dai:
        return 'Áo dài';
      case Style.tu_than:
        return 'Tứ thân';
      case Style.co_phuc:
        return 'Cổ phục';
      case Style.ao_ba_ba:
        return 'Áo bà ba';
      case Style.da_hoi:
        return 'Dạ hội';
      case Style.nang_tho:
        return 'Nàng thơ';
      case Style.hoc_duong:
        return 'Học đường';
      case Style.vintage:
        return 'Vintage';
      case Style.ca_tinh:
        return 'Cá tính';
      case Style.sexy:
        return 'Sexy';
      case Style.cong_so:
        return 'Công sở';
      case Style.dan_toc:
        return 'Dân tộc';
      case Style.do_doi:
        return 'Đồ đôi';
      case Style.hoa_trang:
        return 'Hóa trang';
      case Style.cac_nuoc:
        return 'Các nước';
      default:
        return '';
    }
  }
}

// Extension cho enum Gender
extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Nam';
      case Gender.female:
        return 'Nữ';
      case Gender.unisex:
        return 'Không phân biệt';
      case Gender.other:
        return 'Khác';
      default:
        return '';
    }
  }
}
