import 'package:get/get.dart';

import '../../../../api.config.dart';
import '../../../../core/configs/app_images_string.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/bill_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class RatingController extends GetxController {
  final apiService = ApiService(apiServiceURL);

  final GetuserUseCase _getuserUseCase;
  RatingController(this._getuserUseCase);

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

  bool isValidRating(double rating, String comment) {
    if (rating == 0.0 || comment.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng chọn mức đánh giá và nhập nhận xét');
      return false;
    }

    final isValidComment = RegExp(r'\w+').hasMatch(comment.trim());
    if (!isValidComment) {
      Get.snackbar('Lỗi', 'Vui lòng nhập nhận xét hợp lệ');
      return false;
    }

    return true;
  }

  Future<void> submitRating(
      String billId, String idItem, double rating, String comment) async {
        if (!isValidRating(rating, comment)) return;
    try {
      final response = await apiService.postData(
        'rating/$billId/$idItem',
        {
          'ratingstar': rating,
          'ratingcomment': comment,
        },
        accessToken: auth!.metadata,
      );

      if (response['success']) {
        Get.snackbar('Thành công', 'Đánh giá đã được gửi');
        Get.offNamedUntil(Routes.splash, (route) => false);
      } else {
        Get.snackbar('Thất bại', 'Không thể gửi đánh giá');
      }
    } catch (e) {
      print('Error submitting rating: $e');
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
