import 'package:epose_app/api.config.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_images_string.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/bill_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class DetailsBillController extends GetxController {
  final apiService = ApiService(apiServiceURL);

  final GetuserUseCase _getuserUseCase;
  DetailsBillController(this._getuserUseCase);

  final String billId = Get.arguments['idBill'];

  UserModel? user;
  AuthenticationModel? auth;
  Rx<BillModel?> billDetails = Rx<BillModel?>(null);

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
    await fetchBillDetails();
  }

  Future<void> fetchBillDetails() async {
    try {
      final response = await apiService.getData(
        'bill/$billId',
        accessToken: auth!.metadata,
      );

      if (response['success']) {
        billDetails.value = BillModel.fromJson(response['data']);
      } else {
        print("Failed to fetch bill details");
      }
    } catch (e) {
      print("Error fetching bill details: $e");
    }
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
