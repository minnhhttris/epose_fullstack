import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../api.config.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/bagShopping_model.dart';
import '../../../../core/services/model/bill_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class LendDetailsController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getUserBagShoppingEndpoint = 'bagShopping/';
  final String createPaymentVnpayEndpoint = 'payments/create_payment_url';

  final GetuserUseCase _getuserUseCase;
  LendDetailsController(this._getuserUseCase);

  var isLoading = false.obs;

  UserModel? user;
  AuthenticationModel? auth;

  var bagItems = <BagItemModel>[].obs;
  var billItems = <BillItemModel>[].obs; 
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    init();
    final arguments = Get.arguments;
    print(arguments.length);

    if (arguments != null) {
      if (arguments is Map<String, dynamic> &&
          arguments.containsKey('billItems')) {
        billItems.value = List<BillItemModel>.from(arguments['billItems']);
      } else if (arguments is List<BagItemModel>) {
        print(arguments);
        bagItems.value = arguments;
        print(bagItems);
        convertBagToBillItems();
      }

      // Kiểm tra và chuyển đổi kiểu cho startDate và endDate
      if (arguments is Map<String, dynamic>) {
        if (arguments.containsKey('startDate')) {
          startDate.value = _parseDateTime(arguments['startDate']);
        }
        if (arguments.containsKey('endDate')) {
          endDate.value = _parseDateTime(arguments['endDate']);
        }
      }
    }
  }

  DateTime? _parseDateTime(dynamic date) {
    if (date is String) {
      try {
        return DateFormat('yyyy-MM-dd').parse(date);
      } catch (e) {
        print('Error parsing date: $e');
        return null;
      }
    } else if (date is DateTime) {
      return date;
    }
    return null;
  }

  void init() async {
    isLoading(true);
    user = await _getuserUseCase.getUser();
    auth = await _getuserUseCase.getToken();
    isLoading(false);
  }

  void convertBagToBillItems() {
    final convertedBillItems = bagItems.map((bagItem) {
      return BillItemModel(
        idBill: '', 
        idItem: bagItem.idItem,
        size: bagItem.size,
        quantity: bagItem.quantity,
        clothes: bagItem.clothes,
      );
    }).toList();

    billItems.value = convertedBillItems; 
  }

  void setRentalDates(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
  }

   bool isValidRentalDetails() {
    return startDate.value != null &&
        endDate.value != null &&
        billItems.isNotEmpty;
  }

  Future<void> createBillAndRedirectToPayment() async {
    if (!isValidRentalDetails()) {
      Get.snackbar("Lỗi", "Vui lòng chọn đầy đủ ngày thuê và sản phẩm!");
      return;
    }

    isLoading.value = true;

    final dataBill = {
      'sum': calculateTotalPrice(),
      'downpayment': 0.0,
      'dateStart': startDate.value?.toIso8601String(),
      'dateEnd': endDate.value?.toIso8601String(),
      'items': billItems
          .map((item) => {
                'idItem': item.idItem,
                'quantity': item.quantity,
                'size': item.size,
              })
          .toList(),
    };
    print(dataBill);
    try {
      // Gọi API tạo hóa đơn với idUser và idStore
      final idUser = user?.idUser;
      final idStore = billItems.first.clothes.idStore;

      final billResponse = await apiService.postData(
        'bill/$idUser/$idStore',
        dataBill,
        accessToken: auth!.metadata,
      );

      if (billResponse['success']) {
        final billId = billResponse['data']['idBill'];

        // Gọi API tạo URL thanh toán VNPay
        final paymentResponse = await apiService.postData(
          createPaymentVnpayEndpoint,
          {'idBill': billId, 'downpayment': calculateTotalPrice()},
          accessToken: auth!.metadata,
        );

        if (paymentResponse['statusCode'] == 200) {
          final paymentUrl = paymentResponse['data']['url'];
          Get.toNamed(Routes.paymentVNPay, arguments: {'url': paymentUrl});
        } else {
          Get.snackbar("Lỗi", "Không thể tạo liên kết thanh toán!");
        }
      } else {
        Get.snackbar("Lỗi", "Không thể tạo hóa đơn!");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Có lỗi xảy ra: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  double calculateTotalPrice() {
    int totalDays = endDate.value!.difference(startDate.value!).inDays;
    if (totalDays < 3) totalDays = 3; 

    return billItems.fold<double>(
      0,
      (sum, item) => sum + (item.clothes.price * item.quantity * totalDays),
    );
  }
  
}
