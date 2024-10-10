import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_dimens.dart';
import '../../../../core/ui/widgets/button/button_widget.dart';
import '../../../../core/ui/widgets/text/text_widget.dart';
import '../../../../core/ui/widgets/textfield/custom_textfield_widget.dart';
import '../controller/verifyOTP_controller.dart';

class VerifyOTPPage extends GetView<VerifyOTPController> {
  const VerifyOTPPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            tilteVerifyOTP(),
            const SizedBox(height: 60),
            textfieldOTP(),
            const SizedBox(height: 20),
            Obx(() => TextWidget(
                  text: 'Gửi lại sau : ${controller.countdown.value} s',
                  size: AppDimens.textSize14,
                  color: AppColors.grey,
                )),
            const SizedBox(height: 20),
            Obx(() => ButtonWidget(
                  ontap: controller.countdown.value > 0
                      ? () {
                          controller.verifyOtp(); 
                        }
                      : () {
                          controller.resendOtp(); 
                        },
                  text: controller.countdown.value > 0 ? 'Xác nhận' : 'Gửi lại',
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                  height: 52,
                  borderRadius: 10.0,
                )),
          ],
        ),
      ),
    );
  }

  Column tilteVerifyOTP() {
    return const Column(
      children: [
        TextWidget(
          text: 'Xác nhận email',
          size: AppDimens.textSize42,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        SizedBox(height: 10),
        TextWidget(
          text: 'Vui lòng kiểm tra hộp thư của bạn\nđể nhận mã xác nhận!',
          textAlign: TextAlign.center,
          size: AppDimens.textSize14,
          color: AppColors.grey,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  CustomTextFieldWidget textfieldOTP() {
    return CustomTextFieldWidget(
      decorationType: InputDecorationType.underline,
      controller: controller.otpController,
      hintText: 'Nhập OTP...',
      hintColor: AppColors.grey1,
      backgroundColor: AppColors.white,
      focusedColor: AppColors.primary,
      enableColor: AppColors.primary,
      keyboardType: TextInputType.number,
      textColor: AppColors.black,
      obscureText: false,
    );
  }
}
