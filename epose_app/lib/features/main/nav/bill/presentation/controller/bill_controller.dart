import 'package:get/get.dart';
import 'package:epose_app/api.config.dart';
import 'package:epose_app/core/services/api.service.dart';
import 'package:epose_app/core/services/user/domain/use_case/get_user_use_case.dart';
import 'package:epose_app/core/services/model/bill_model.dart';
import 'package:epose_app/core/services/user/model/auth_model.dart';
import 'package:epose_app/core/services/user/model/user_model.dart';

import '../../../../../../core/configs/app_images_string.dart';

class BillController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;

  BillController(this._getuserUseCase);

  UserModel? user;
  AuthenticationModel? auth;
  RxList<BillModel> bills = <BillModel>[].obs;
  RxString selectedStatus = 'Tất cả'.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
    fetchBills();
  }

  Future<void> fetchBills() async {
    if (user == null || auth == null) return;

    try {
      final responseData = await apiService.getData(
        'bill/user/${user!.idUser}',
        accessToken: auth!.metadata,
      );

      if (responseData['success']) {
        bills.value = (responseData['data'] as List)
            .map((json) => BillModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Error fetching bills: $e');
    }
  }

  List<String> get orderStatus =>
      ['Tất cả', ...statementMapping.values.map((e) => e['label']).toList()];

  List<BillModel> get filteredBills {
    if (selectedStatus.value == 'Tất cả') {
      return bills;
    } else {
      return bills
          .where((bill) =>
              statementMapping[bill.statement]!['label'] ==
              selectedStatus.value)
          .toList();
    }
  }

  void changeSelectedStatus(String status) {
    selectedStatus.value = status;
  }

  Statement getStatementFromStatus(String status) {
    return statementMapping.entries
        .firstWhere(
          (entry) => entry.value['label'] == status,
          orElse: () =>
              statementMapping.entries.first, 
        )
        .key;
  }


  final Map<Statement, Map<String, dynamic>> statementMapping = {
    Statement.UNPAID: {
      'label': 'Chưa thanh toán',
      'icon': AppImagesString.ePaid,
    },
    Statement.PAID: {
      'label': 'Đã thanh toán',
      'icon': AppImagesString.ePaid,
    },
    Statement.CONFIRMED: {
      'label': 'Xác nhận',
      'icon': AppImagesString.eConfirmed,
    },
    Statement.PENDING_PICKUP: {
      'label': 'Chờ lấy hàng',
      'icon': AppImagesString.ePendingPickup,
    },
    Statement.DELIVERING: {
      'label': 'Đang giao',
      'icon': AppImagesString.eDelivering,
    },
    Statement.DELIVERED: {
      'label': 'Đã giao',
      'icon': AppImagesString.eDelivered,
    },
    Statement.CANCELLED: {
      'label': 'Đã hủy',
      'icon': AppImagesString.eCancelled,
    },
    Statement.RETURNED: {
      'label': 'Trả hàng',
      'icon': AppImagesString.eReturned,
    },
    Statement.COMPLETED: {
      'label': 'Hoàn thành',
      'icon': AppImagesString.eCompleted,
    },
  };
}
