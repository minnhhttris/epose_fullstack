import 'package:get/get.dart';
import 'package:epose_app/api.config.dart';
import 'package:epose_app/core/services/api.service.dart';
import 'package:epose_app/core/services/user/domain/use_case/get_user_use_case.dart';
import 'package:epose_app/core/services/model/bill_model.dart';
import 'package:epose_app/core/services/user/model/auth_model.dart';
import 'package:epose_app/core/services/user/model/user_model.dart';

import '../../../../../../core/configs/app_images_string.dart';
import '../../../../../../core/services/model/bagShopping_model.dart';

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
    getBagShopping();
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

  final String getUserBagShoppingEndpoint = 'bagShopping/';
  BagShoppingModel? bagShopping;
  var isLoadingBag = false.obs;

  Future<void> getBagShopping() async {
    isLoadingBag.value = true; // Bắt đầu tải
    try {
      final response = await apiService.getData(
        getUserBagShoppingEndpoint,
        accessToken: auth?.metadata,
      );
      if (response['success']) {
        bagShopping = BagShoppingModel.fromJson(response['data']);
        print("Bag shopping loaded successfully: ${bagShopping?.items.length}");
        update(); // Thông báo cho giao diện
      } else {
        print("Failed to load bag shopping: ${response['statusCode']}");
      }
    } catch (e) {
      print("Error fetching bag shopping: $e");
    } finally {
      isLoadingBag.value = false; // Kết thúc tải
    }
  }

  List<String> get orderStatus =>
      ['Tất cả', ...statementMapping.values.map((e) => e['label']).toList()];

  List<BillModel> get filteredBills {
    if (selectedStatus.value == 'Tất cả') {
      // Filter out bills that have an invalid status in statementMapping
      return bills.where((bill) {
        final statement = statementMapping[bill.statement];
        // Only include bills that have a valid status in statementMapping
        return statement != null;
      }).toList();
    } else {
      // Filter bills based on the selected status
      return bills.where((bill) {
        final statement = statementMapping[bill.statement];
        // Ensure the bill's status exists in statementMapping before filtering
        return statement != null && statement['label'] == selectedStatus.value;
      }).toList();
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
      'icon': AppImagesString.eUnPaid,
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
    Statement.RATING: {
      'label': 'Đánh giá',
      'icon': AppImagesString.eRating,
    },
  };
}
