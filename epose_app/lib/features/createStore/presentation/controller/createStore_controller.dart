import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../api.config.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';



class CreateStoreController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;

  CreateStoreController(this._getuserUseCase);

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
  var logoFile = Rx<File?>(null); // File to hold logo

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
    isLoading.value = false;
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
        print(response.body);
        final data = json.decode(utf8.decode(response.bodyBytes))
            as Map<String, dynamic>;
        wards.value = List<Map<String, String>>.from(data['wards'].map((w) {
          return {
            'name': w['name'].toString(),
            'code': w['code'].toString(),
          };
        }));
        print(wards);
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

  Future<void> createStore() async {
    final fullAddress =
        "${addressDetailController.text}, ${selectedWard.value}, ${selectedDistrict.value}, ${selectedProvince.value}";

    var storeData = {
      'idUser': user?.idUser ?? '',
      'nameStore': nameStore.value,
      'license': license.value,
      'taxCode': taxCode.value,
      'address': fullAddress,
    };

    Map<String, String> fields =
        storeData.map((key, value) => MapEntry(key, value));

    Map<String, File> singleFiles = {};
    if (logoFile.value != null) {
      singleFiles['logo'] = logoFile.value!; // Attach the logo file
    }

    // Making a multipart request to send the data
    try {
      final response = await apiService.postMultipartData(
        'stores/createStore',
        fields,
        singleFiles,
        {},
        accessToken: auth?.metadata,
      );

      if (response['success']) {
        Get.snackbar("Success", "Tạo cửa hàng thành công vui lòng đợt duyệt!");
        Get.offNamedUntil(Routes.splash, (route) => false);
      } 
    } catch (e) {
      Get.snackbar("Error", "Có lỗi xảy ra " + e.toString());
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
