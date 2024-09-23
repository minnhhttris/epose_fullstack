import 'package:epose_app/core/configs/app_colors.dart';
import 'package:epose_app/core/configs/app_dimens.dart';
import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/setPin_controller.dart';

class SetPinPage extends GetView<SetPinController> {
  const SetPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                TextWidget(
                  text: controller.isConfirmStep.value
                      ? "Xác nhận mã PIN"
                      : "Đặt mã PIN",
                  size: AppDimens.textSize42,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 10),
                TextWidget(
                  text: controller.isConfirmStep.value
                      ? "Vui lòng xác nhận lại mã PIN vừa nhập nhé!"
                      : "Vui lòng đặt mã PIN cho ứng dụng của bạn!",
                  textAlign: TextAlign.center,
                  color: AppColors.grey,
                  size: AppDimens.textSize16,
                ),
                const SizedBox(height: 40),
                PinInputField(
                  controllers: controller.isConfirmStep.value
                      ? controller.confirmPinControllers
                      : controller.pinControllers,
                ),
                const SizedBox(height: 40),
                ButtonWidget(
                  ontap: controller.isConfirmStep.value
                      ? controller.confirmPin
                      : controller.goToConfirmStep,
                  text:
                      controller.isConfirmStep.value ? "Xác nhận" : "Hoàn tất",
                ),
                if (controller.isConfirmStep.value)
                  TextButton(
                    onPressed: controller.resetPin,
                    child: const Text(
                      "Nhập lại mã PIN",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: AppDimens.textSize16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PinInputField extends StatelessWidget {
  final List<TextEditingController> controllers;

  // ignore: use_key_in_widget_constructors
  const PinInputField({required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          width: 54,
          height: 54,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
          child: Center(
            child: TextField(
              controller: controllers[index],
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              onChanged: (value) {
                if (value.length == 1 && index < 3) {
                  FocusScope.of(context)
                      .nextFocus(); // Di chuyển sang TextField tiếp theo
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(context)
                      .previousFocus(); // Quay lại TextField trước đó nếu xóa
                }
              },
            ),
          ),
        );
      }),
    );
  }
}
