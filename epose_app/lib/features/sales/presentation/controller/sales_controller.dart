import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/store_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';
import '../../../../core/services/model/bill_model.dart';

class SalesController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;
  SalesController(this._getuserUseCase);

  UserModel? user;
  StoreModel? store;
  AuthenticationModel? auth;

  List<BillModel> bills = [];

  var isLoading = false.obs;
  var totalRevenue = 0.0.obs;
  var monthlyRevenue = 0.0.obs;
  var yearlyRevenue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    isLoading.value = true;
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
    await getMyStore();
    calculateRevenue();
    isLoading.value = false;
  }

  Future<void> getMyStore() async {
    var userId = user!.idUser;
    try {
      final response = await apiService.getData('stores/user/$userId',
          accessToken: auth!.metadata);
      if (response['success']) {
        store = StoreModel.fromJson(response['data']);
        if (store != null) {
          await getBillsByStore(store!.idStore);
        }
      }
    } catch (e) {
      print("Error fetching store: $e");
    }
  }

  Future<void> getBillsByStore(String storeId) async {
    try {
      final response = await apiService.getData('bill/store/$storeId',
          accessToken: auth!.metadata);
      if (response['success']) {
        bills = List<BillModel>.from(
          response['data'].map((x) => BillModel.fromJson(x)),
        );
      }
    } catch (e) {
      print("Error fetching bills: $e");
    }
  }

  void calculateRevenue() {
    // Lọc hóa đơn chỉ lấy các trạng thái COMPLETED hoặc RATING
    final filteredBills = bills.where((bill) =>
        bill.statement == Statement.COMPLETED ||
        bill.statement == Statement.RATING);

    // Tính tổng doanh thu
    totalRevenue.value = filteredBills.fold(0, (sum, bill) => sum + bill.sum);

    // Tính doanh thu theo tháng
    final now = DateTime.now();
    monthlyRevenue.value = filteredBills
        .where((bill) =>
            bill.createdAt.month == now.month &&
            bill.createdAt.year == now.year)
        .fold(0, (sum, bill) => sum + bill.sum);

    // Tính doanh thu theo năm
    yearlyRevenue.value = filteredBills
        .where((bill) => bill.createdAt.year == now.year)
        .fold(0, (sum, bill) => sum + bill.sum);
  }

  var displayByMonth = true.obs; // true = Tháng, false = Năm

  List<FlSpot> generateLineChartData() {
    final now = DateTime.now();

    if (bills.isEmpty) {
      return [];
    }

    if (displayByMonth.value) {
      // Tạo dữ liệu theo ngày trong tháng hiện tại
      final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
      final dailyRevenue = List.generate(daysInMonth, (_) => 0.0);

      for (var bill in bills) {
        if ((bill.statement == Statement.COMPLETED ||
                bill.statement == Statement.RATING) &&
            bill.createdAt.month == now.month &&
            bill.createdAt.year == now.year) {
          dailyRevenue[bill.createdAt.day - 1] += bill.sum;
        }
      }

      return List.generate(daysInMonth, (index) {
        return FlSpot(index.toDouble(), dailyRevenue[index]);
      });
    } else {
      // Tạo dữ liệu theo từng tháng trong năm hiện tại
      final monthlyRevenue = List.generate(12, (_) => 0.0);

      for (var bill in bills) {
        if ((bill.statement == Statement.COMPLETED ||
                bill.statement == Statement.RATING) &&
            bill.createdAt.year == now.year) {
          monthlyRevenue[bill.createdAt.month - 1] += bill.sum;
        }
      }

      return List.generate(12, (index) {
        return FlSpot(index.toDouble(), monthlyRevenue[index]);
      });
    }
  }
}
