import 'dart:convert';
import 'package:epose_app/core/services/user/domain/use_case/save_user_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';
import 'package:http/http.dart' as http;

class AddressController extends GetxController {
  final GetuserUseCase _getuserUseCase;
  final SaveUserUseCase _saveUserUseCase;
  AddressController(this._getuserUseCase, this._saveUserUseCase);

  final apiService = ApiService(apiServiceURL);
  final String endpoint = 'users/updateUser';

  var isLoading = false.obs;
  var provinces = <Map<String, String>>[].obs; 
  var districts = <Map<String, String>>[].obs;
  var wards = <Map<String, String>>[].obs;

  var selectedProvince = ''.obs;
  var selectedDistrict = ''.obs;
  var selectedWard = ''.obs;
  var userAddress = ''.obs;
  final addressDetailController = TextEditingController();

  UserModel? user;
  AuthenticationModel? auth;

  @override
  void onInit() {
    super.onInit();
    init();
    fetchProvinces();
  }

  Future<void> init() async {
    isLoading.value = true;
    try {
      user = await _getuserUseCase.getUser();
      auth = await _getuserUseCase.getToken();
      if (user != null && user!.address != null) {
        userAddress.value = user!.address!;
        parseAddress(user!.address!);
        print('User address: ${user!.address}');
      }
    } catch (e) {
      Get.snackbar("Error", "Có lỗi khi tải dữ liệu: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void parseAddress(String fullAddress) async {
  if (fullAddress.isEmpty) {
    print('Error: Full address is empty.');
    return;
  }

  var parts = fullAddress.split(',');
  if (parts.length != 4) {
    print('Error: Address format is invalid. Expected format: "Detail, Ward, District, Province".');
    return;
  }

  // Lưu tên địa chỉ
  if (parts.length == 4) {
      // Lưu tên địa chỉ
      addressDetailController.text = parts[0].trim();
      selectedWard.value = parts[1].trim();
      selectedDistrict.value = parts[2].trim();
      selectedProvince.value = parts[3].trim();

      // Tìm mã tỉnh từ tên tỉnh
      String? provinceCode = await getProvinceCode(parts[3].trim());
      String? districtCode =
          await getDistrictCode(parts[2].trim(), provinceCode!);
      String? wardCode = await getWardCode(parts[1].trim(), districtCode!);

      print(
          'Province: $provinceCode, District: $districtCode, Ward: $wardCode');
    }
}


  Future<String?> getProvinceCode(String provinceName) async {
    if (provinces.isEmpty) {
      // If provinces are not loaded, fetch them first
      await fetchProvinces();
    }

    final province = provinces.firstWhere(
      (p) => p['name'] == provinceName,
      orElse: () => {},
    );

    return province.isNotEmpty ? province['code'] : null;
  }

  Future<String?> getDistrictCode(
      String districtName, String provinceCode) async {
    if (districts.isEmpty) {
      // If districts are not loaded, fetch them first
      await fetchDistricts(provinceCode);
    }

    final district = districts.firstWhere(
      (d) => d['name'] == districtName,
      orElse: () => {},
    );

    return district.isNotEmpty ? district['code'] : null;
  }

  Future<String?> getWardCode(String wardName, String districtCode) async {
    if (wards.isEmpty) {
      // If wards are not loaded, fetch them first
      await fetchWards(districtCode);
    }

    final ward = wards.firstWhere(
      (w) => w['name'] == wardName,
      orElse: () => {},
    );

    return ward.isNotEmpty ? ward['code'] : null;
  }

  Future<void> fetchProvinces() async {
    final url = Uri.parse('https://provinces.open-api.vn/api/p/');
    isLoading.value = true;
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)) as List;
        provinces.value = data.map((province) {
          return {
            'name': province['name'].toString(),
            'code': province['code'].toString()
          };
        }).toList();
      } else {
        Get.snackbar("Error", "Không tải được danh sách tỉnh");
      }
    } catch (e) {
      Get.snackbar("Error", "Có lỗi khi tải danh sách tỉnh: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDistricts(String provinceCode) async {
    final url =
        Uri.parse('https://provinces.open-api.vn/api/p/$provinceCode?depth=2');
    isLoading.value = true;
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes))
            as Map<String, dynamic>;
        districts.value =
            List<Map<String, String>>.from(data['districts'].map((d) {
          return {
            'name': d['name'].toString(),
            'code': d['code'].toString(),
          };
        }));
        wards.clear();
      } else {
        Get.snackbar("Error", "Không tải được danh sách quận/huyện");
      }
    } catch (e) {
      Get.snackbar("Error", "Có lỗi khi tải danh sách quận/huyện: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWards(String districtCode) async {
    final url =
        Uri.parse('https://provinces.open-api.vn/api/d/$districtCode?depth=2');
    isLoading.value = true;
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes))
            as Map<String, dynamic>;
        wards.value = List<Map<String, String>>.from(data['wards'].map((w) {
          return {
            'name': w['name'].toString(),
            'code': w['code'].toString(),
          };
        }));
      } else {
        Get.snackbar("Error", "Không tải được danh sách xã/phường");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Có lỗi khi tải danh sách xã/phường: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String getCodeFromName(List<Map<String, String>> items, String name) {
    final item = items.firstWhere((element) => element['name'] == name,
        orElse: () => {});
    return item['code'] ?? '';
  }

  Future<void> updateInformation() async {
    final fullAddress =
        "${addressDetailController.text}, ${selectedWard.value}, ${selectedDistrict.value}, ${selectedProvince.value}";
    final data = {"address": fullAddress};

    isLoading.value = true;
    try {
      final response = await apiService.postData(endpoint, data,
          accessToken: auth!.metadata);
      if (response['success']) {
        user = UserModel.fromJson(response['data']);
        await _saveUserUseCase.saveUser(user!);
        Get.snackbar("Success", "Cập nhật thông tin thành công");
      } else {
        Get.snackbar("Error", "Cập nhật thông tin thất bại");
      }
    } catch (e) {
      Get.snackbar("Error", "Có lỗi xảy ra: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
