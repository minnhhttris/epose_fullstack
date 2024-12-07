import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../api.config.dart';
import '../../../../core/configs/app_images_string.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/bill_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class ClothesStatusController extends GetxController {
  final apiService = ApiService(apiServiceURL);

  final GetuserUseCase _getuserUseCase;
  ClothesStatusController(this._getuserUseCase);

  final String billId = Get.arguments['idBill'];

  UserModel? user;
  AuthenticationModel? auth;
  Rx<BillModel?> billDetails = Rx<BillModel?>(null);

  RxList<File> listPicture = <File>[].obs;

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

  String getStatusType() {
    final statement = billDetails.value?.statement;
    switch (statement) {
      case Statement.PAID:
        return "CONFIRMED";
      case Statement.DELIVERING:
        return "DELIVERED";
      case Statement.RETURNED:
        return "COMPLETED";
      default:
        throw Exception("Không xác định được trạng thái");
    }
  }

  Future<void> updateBillStatus(String idBill, String status) async {
    try {
      final response = await apiService.putData(
        'bill/$idBill',
        {'statement': status},
        accessToken: auth!.metadata,
      );

      if (response['success']) {
        print("Bill status updated to: $status");
        await fetchBillDetails();
      }
    } catch (e) {
      print("Error updating bill status: $e");
      Get.snackbar("Lỗi", "Có lỗi xảy ra: ${e.toString()}");
    }
  }

  Future<void> createClothesStatus(
      String idBill, String idItem, String description) async {
    try {
      final statusType = getStatusType();

      updateBillStatus(idBill, statusType);

      final response = await apiService.postMultipartData(
        'clothesStatus/bill/$billId/createClothesStatus',
        {
          'description': description,
          'statusType': statusType,
          'idBill': billId,
          'idItem': idItem,
        },
        {},
        {
          'images': listPicture,
        },
        accessToken: auth?.metadata,
      );

      if (response['success']) {
        Get.back(result: true);
        Get.snackbar(
            "Thành công", "Trạng thái quần áo đã được cập nhật thành công!");
      }
    } catch (e) {
      print("Error creating clothes status: $e");
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages != null) {
      listPicture
          .addAll(pickedImages.map((image) => File(image.path)).toList());
    }
  }

  // Xóa hình ảnh
  void removeImage(File image) {
    listPicture.remove(image);
  }

  bool checkListEmpty() {
    return listPicture.isEmpty;
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
