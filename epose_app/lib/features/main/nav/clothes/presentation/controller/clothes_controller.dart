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
  List<ClothesModel> filteredClothes = [];

  var isLoading = false.obs;

  // Biến trạng thái cho bộ lọc
  var selectedColors = <Color>[].obs;
  var selectedStyles = <Style>[].obs;
  var selectedGenders = <Gender>[].obs;
  var minPrice = 0.0.obs;
  var maxPrice = 0.0.obs;

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
        filteredClothes = List.from(listClothes);
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

  var isGenderFilterOpen = false.obs;
  var isColorFilterOpen = false.obs;
  var isStyleFilterOpen = false.obs;
  var isPriceFilterOpen = false.obs;

  // Hàm để thiết lập lại bộ lọc
  void resetFilters() {
    isLoading.value = true;

    selectedColors.clear();
    selectedStyles.clear();
    selectedGenders.clear();
    minPrice.value = 0.0;
    maxPrice.value = 0.0;
    filteredClothes = List.from(listClothes);
    update();

    isLoading.value = false;
  }

  // Hàm để áp dụng bộ lọc
  void applyFilters() {
    isLoading.value = true;
    filteredClothes = listClothes.where((clothes) {
      final matchesColor =
          selectedColors.isEmpty || selectedColors.contains(clothes.color);
      final matchesStyle =
          selectedStyles.isEmpty || selectedStyles.contains(clothes.style);
      final matchesGender =
          selectedGenders.isEmpty || selectedGenders.contains(clothes.gender);
      final matchesPrice =
          (minPrice.value == 0.0 || clothes.price >= minPrice.value) &&
              (maxPrice.value == 0.0 || clothes.price <= maxPrice.value);
      return matchesColor && matchesStyle && matchesGender && matchesPrice;
    }).toList();

    update(); 
    isFilterMenuOpen.value = false;
    isLoading.value = false;
    print(
        "Bộ lọc đã được áp dụng, số lượng quần áo lọc: ${filteredClothes.length}");
  }
}
