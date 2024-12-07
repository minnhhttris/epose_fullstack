import 'package:epose_app/api.config.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_images_string.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/bill_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class DetailsBillController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String createPaymentVnpayEndpoint = 'payments/create_payment_url';

  final GetuserUseCase _getuserUseCase;
  DetailsBillController(this._getuserUseCase);

  final String billId = Get.arguments['idBill'];

  UserModel? user;
  AuthenticationModel? auth;
  Rx<BillModel?> billDetails = Rx<BillModel?>(null);
  var isLoading = false.obs;

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
    isLoading.value = true;
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> redirectToPayment (String idBill, double downpayment) async {
    try {
      final paymentResponse = await apiService.postData(
        createPaymentVnpayEndpoint,
        {'idBill': idBill, 'downpayment': downpayment},
        accessToken: auth!.metadata,
      );

      if (paymentResponse['statusCode'] == 200) {
        final paymentUrl = paymentResponse['data']['url'];
        Get.toNamed(Routes.paymentVNPay, arguments: {'url': paymentUrl});
      } else {
        Get.snackbar("Lỗi", "Không thể tạo liên kết thanh toán!");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updateBillStatus(String idBill, Statement newStatus) async {
    try {
      print("Updating bill status to: $newStatus");
      var status = newStatus.toString().split('.').last;
      print("Status: $status");
      final response = await apiService.putData(
        'bill/$idBill',
        {'statement': status},
        accessToken: auth!.metadata,
      );

      if (response['success']) {
        await fetchBillDetails(); 
        Get.snackbar("Thành công", "Trạng thái đã được cập nhật.");
      } else {
        Get.snackbar("Lỗi", "Không thể cập nhật trạng thái.");
      }
    } catch (e) {
      print("Error updating bill status: $e");
      Get.snackbar("Lỗi", "Có lỗi xảy ra: ${e.toString()}");
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
    Statement.RATING: {
      'label': 'Đánh giá',
      'icon': AppImagesString.eRating,
    },
  };
}
