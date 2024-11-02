import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/model/bagShopping_model.dart';
import '../../../../core/services/model/bill_model.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/auth_model.dart';
import '../../../../core/services/user/model/user_model.dart';

class LendDetailsController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final String getUserBagShoppingEndpoint = 'bagShopping/';

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

    billItems.value = convertedBillItems; // Gán danh sách BillItemModel
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
  
}
