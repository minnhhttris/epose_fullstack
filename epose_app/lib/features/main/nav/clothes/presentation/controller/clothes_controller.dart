import 'package:epose_app/core/services/user/model/auth_model.dart';
import 'package:get/get.dart';

import '../../../../../../api.config.dart';
import '../../../../../../core/services/api.service.dart';
import '../../../../../../core/services/model/clothes_model.dart';
import '../../../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../../../core/services/user/model/user_model.dart';

class ClothesController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getAllClothesEndpoint = 'clothes/';

  final GetuserUseCase _getuserUseCase;
  ClothesController(this._getuserUseCase);

  UserModel? user;
  AuthenticationModel? auth;

  List<ClothesModel> listClothes = [];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    init();
    getAllClothes();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
  }

  //getAllClothes
  Future<void> getAllClothes() async {
    isLoading.value = true;
    try {
      
      final response = await apiService.getData(getAllClothesEndpoint);
      if (response['success']) {
        listClothes = List<ClothesModel>.from(
          response['data'].map((x) => ClothesModel.fromJson(x)),
        );
  
        update();
      } 
    } catch (e) {
      Get.snackbar("Error", "Error fetching clothes: ${e.toString()}");
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

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
