import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class EditStoreController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;

  EditStoreController(this._getuserUseCase);

  UserModel? user;
  AuthenticationModel? auth;
  var isLoading = false.obs;

  // Address-related fields
  var provinces = <Map<String, String>>[].obs;
  var districts = <Map<String, String>>[].obs;
  var wards = <Map<String, String>>[].obs;
  var selectedProvince = ''.obs;
  var selectedDistrict = ''.obs;
  var selectedWard = ''.obs;
  var addressDetailController = TextEditingController();

  // Store fields
  var nameStore = ''.obs;
  var license = ''.obs;
  var taxCode = ''.obs;
  var logoFile = Rx<dynamic>(null);
  var storeId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    init();
    fetchProvinces();
  }

  Future<void> init() async {
    isLoading.value = true;
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
    await getMyStore();
    isLoading.value = false;
  }

  Future<void> getMyStore() async {
    if (user == null || auth == null) return;
    var userId = user!.idUser;
    try {
      final response = await apiService.getData('stores/user/$userId',
          accessToken: auth!.metadata);

      if (response['success']) {
        final store = response['data'];
        if (store != null) {
          storeId.value = store['idStore'];
          nameStore.value = store['nameStore'];
          license.value = store['license'];
          taxCode.value = store['taxCode'];
          addressDetailController.text = store['address'];
          var fullAddress = store['address'];
          parseAddress(fullAddress);
          var logo = store['logo'];
          if (logo.startsWith('http')) {
            logoFile.value = logo;
          } else {
            logoFile.value = File(logo);
          }
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Có lỗi xảy ra khi lấy thông tin cửa hàng.");
    }
  }

  void parseAddress(String fullAddress) async {
    if (fullAddress.isEmpty) {
      print('Error: Full address is empty.');
      return;
    }

    var parts = fullAddress.split(',');
    if (parts.length != 4) {
      print(
          'Error: Address format is invalid. Expected format: "Detail, Ward, District, Province".');
      return;
    }
    
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

      print('Province: $provinceCode, District: $districtCode, Ward: $wardCode');
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

  // Cập nhật Store
  Future<void> updateStore() async {
    final fullAddress =
        "${addressDetailController.text}, ${selectedWard.value}, ${selectedDistrict.value}, ${selectedProvince.value}";

    Map<String, File> singleFiles = {};

    // Kiểm tra và xử lý logo
    if (logoFile.value != null) {
      if (logoFile.value is File) {
        // Nếu logo là một file
        singleFiles['logo'] = logoFile.value;
      } else if (logoFile.value is String &&
          logoFile.value.startsWith('http')) {
        // Nếu logo là một URL, không cần gửi file
        print('Logo là URL: ${logoFile.value}');
      } else {
        // Trường hợp không hợp lệ
        Get.snackbar("Lỗi", "Logo không hợp lệ.");
        return;
      }
    }

    // Making a multipart request to send the data
    try {
      final response = await apiService.postMultipartData(
        'stores/updateStore',
        {
          'idUser': user?.idUser ?? '',
          'idStore': storeId.value,
          'nameStore': nameStore.value,
          'license': license.value,
          'taxCode': taxCode.value,
          'address': fullAddress,
          'logo':
              (logoFile.value is String && logoFile.value.startsWith('http'))
                  ? logoFile.value
                  : '',
        },
        singleFiles,
        {},
        accessToken: auth?.metadata,
      );

      if (response['success']) {
        Get.back(result: true);
        Get.snackbar("Success", "Cập nhật cửa hàng thành công!");
        
      } else {
        Get.snackbar("Error", "Có lỗi xảy ra khi cập nhật cửa hàng.");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Có lỗi xảy ra " + e.toString());
    } finally {
      isLoading.value = false;
    }
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
}
