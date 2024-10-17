import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/user_model.dart';

class SetPinController extends GetxController {
  final GetuserUseCase _getuserUseCase;
  SetPinController(this._getuserUseCase);

  UserModel? user;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    user = await _getuserUseCase.getUser();
  }
  
  // Danh sách các TextEditingController cho từng ô nhập
  final pinControllers = List.generate(4, (_) => TextEditingController()).obs;
  final confirmPinControllers =
      List.generate(4, (_) => TextEditingController()).obs;

  var isConfirmStep = false.obs;

  @override
  void onClose() {
    pinControllers.forEach((controller) => controller.dispose());
    confirmPinControllers.forEach((controller) => controller.dispose());
    super.onClose();
  }

  void goToConfirmStep() {
    if (_isPinValid(pinControllers)) {
      isConfirmStep.value = true;
    } else {
      Get.snackbar('Lỗi', 'Vui lòng nhập đầy đủ 4 chữ số cho mã PIN!',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Hàm xác nhận mã PIN
  void confirmPin() {
    if (_getPinFromControllers(pinControllers) ==
        _getPinFromControllers(confirmPinControllers)) {
      Get.snackbar('Thành công', 'Mã PIN của bạn đã được thiết lập thành công!',
          snackPosition: SnackPosition.BOTTOM);
      // lưu mã PIN vào cơ sở dữ liệu.
    } else {
      Get.snackbar('Lỗi', 'Mã PIN không khớp, vui lòng thử lại!',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Đặt lại mã PIN
  void resetPin() {
    pinControllers.forEach((controller) => controller.clear());
    confirmPinControllers.forEach((controller) => controller.clear());
    isConfirmStep.value = false;
  }

  // Kiểm tra mã PIN hợp lệ
  bool _isPinValid(List<TextEditingController> controllers) {
    return controllers.every((controller) =>
        controller.text.isNotEmpty && controller.text.length == 1);
  }

  // Lấy mã PIN từ các ô nhập
  String _getPinFromControllers(List<TextEditingController> controllers) {
    return controllers.map((controller) => controller.text).join();
  }
}
