import 'package:get/get.dart';
import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/clothes_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class ClothesByStyleController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getAllClothesEndpoint = 'clothes/';
  final GetuserUseCase _getuserUseCase;

  ClothesByStyleController(this._getuserUseCase);

  UserModel? user;
  AuthenticationModel? auth;

  var listClothes = <ClothesModel>[].obs;
  var isLoading = false.obs;
  var styleName = ''.obs; 

  @override
  void onInit() {
    super.onInit();
    init();
    
    styleName.value = Get.arguments;
   
    getAllClothes();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
  }

  Future<void> getAllClothes() async {
    isLoading.value = true;
    try {
      final response = await apiService.getData(getAllClothesEndpoint);
      if (response['success']) {
        listClothes.value = List<ClothesModel>.from(
          response['data'].map((x) => ClothesModel.fromJson(x)),
        );
        filterClothesByStyle();
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching clothes: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void filterClothesByStyle() {
    // Lọc sản phẩm theo kiểu style với điều kiện hiển thị đúng
    listClothes.value = listClothes
        .where((item) => item.style.displayName == styleName.value)
        .toList();
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

