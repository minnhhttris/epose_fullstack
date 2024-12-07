
import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';
import '../../../../api.config.dart';
import '../../../../core/configs/enum.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/clothes_model.dart';
import '../../../../core/services/model/store_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';
import '../../../../core/ui/dialogs/dialogs.dart';

class SearchController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getAllClothesEndpoint = 'clothes/';
  final GetuserUseCase _getuserUseCase;

  SearchController(this._getuserUseCase);

  UserModel? user;
  AuthenticationModel? auth;
  StoreModel? store;

  var listClothes = <ClothesModel>[].obs;
  var isLoading = false.obs;
  var searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    init();
    getAllClothes();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
    getMyStore();
  }

  Future<void> getAllClothes() async {
    isLoading.value = true;
    try {
      final response = await apiService.getData(getAllClothesEndpoint);
      if (response['success']) {
        listClothes.value = List<ClothesModel>.from(
          response['data'].map((x) => ClothesModel.fromJson(x)),
        );
        listClothes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching clothes: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm tìm kiếm quần áo
  void searchClothes(String query) {
    searchText.value = query;

    if (query.isEmpty) {
      getAllClothes(); 
    } else {
      // Loại bỏ dấu và chuyển thành chữ thường
      String normalizedQuery = removeDiacritics(query.toLowerCase());

      // Tách query thành các từ khóa
      List<String> keywords =
          normalizedQuery.split(' ').where((word) => word.isNotEmpty).toList();

      listClothes.value = listClothes.where((item) {
        // Loại bỏ dấu và chuyển tất cả các thuộc tính về chữ thường để tìm kiếm
        final normalizedNameItem =
            removeDiacritics(item.nameItem.toLowerCase());
        final normalizedGender =
            removeDiacritics(item.gender.displayName.toLowerCase());
        final normalizedColor =
            removeDiacritics(item.color.displayName.toLowerCase());
        final normalizedStyle =
            removeDiacritics(item.style.displayName.toLowerCase());

        // Kiểm tra xem tất cả các từ khóa có xuất hiện trong ít nhất một thuộc tính không
        return keywords.every((keyword) =>
            normalizedNameItem.contains(keyword) ||
            normalizedGender.contains(keyword) ||
            normalizedColor.contains(keyword) ||
            normalizedStyle.contains(keyword));
      }).toList();
    }
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
}

// Extension cho enum Color
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
