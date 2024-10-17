import 'package:get/get.dart';

import '../../../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../../../core/services/user/model/user_model.dart';

class BillController extends GetxController {
  final GetuserUseCase _getuserUseCase;
  BillController(this._getuserUseCase);

  UserModel? user;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
  }
  // Danh sách các trạng thái đơn hàng
  final List<String> orderStatus = [
    'Tất cả',
    'Thanh toán',
    'Xác nhận',
    'Chờ lấy hàng',
    'Đang giao',
    'Đã giao',
    'Đã hủy',
    'Trả hàng'
  ];

  // Trạng thái đã chọn
  var selectedStatus = 'Tất cả'.obs;

  // Danh sách đơn hàng
  var orders = [
    {
      'status': 'Thanh toán',
      'productName': 'Áo dài đỏ Tết truyền thống',
      'rentalPeriod': '1/2/2024 đến 4/2/2024',
      'imageUrl': "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg"
    },
    {
      'status': 'Đang giao',
      'productName': 'Áo dài đỏ Tết truyền thống',
      'rentalPeriod': '1/2/2024 đến 4/2/2024',
      'imageUrl': "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg"
    },
    {
      'status': 'Đang giao',
      'productName': 'Áo dài đỏ Tết truyền thống',
      'rentalPeriod': '1/2/2024 đến 4/2/2024',
      'imageUrl':
          "https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg"
    },
  ].obs;

  // Lọc đơn hàng theo trạng thái
  List<Map<String, String>> get filteredOrders {
    if (selectedStatus.value == 'Tất cả') {
      return orders;
    } else {
      return orders
          .where((order) => order['status'] == selectedStatus.value)
          .toList();
    }
  }

  // Thay đổi trạng thái đã chọn
  void changeSelectedStatus(String status) {
    selectedStatus.value = status;
  }
}
