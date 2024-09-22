import 'package:epose_app/core/configs/app_dimens.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_images_string.dart';
import '../../../../core/configs/app_colors.dart';
import '../controller/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary3,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImagesString.eEposeLogo,
                  width: 200.0,
                  height: 200.0,
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          Positioned(
            bottom: Get.height*0.1, 
            left: 70.0, 
            right: 70.0, 
            child: Column(
              children: [
                Obx(() => LinearProgressIndicator(
                      value: controller.loadingValue.value,
                      backgroundColor: AppColors.grey1,
                      borderRadius: BorderRadius.circular(5.0),
                      color: AppColors.primary, // Màu nâu cho thanh tiến trình
                      minHeight: 8.0, // Chiều cao thanh tiến trình
                    )),
                const SizedBox(height: 10.0),
                Obx(() => TextWidget(
                      text: '${(controller.loadingValue.value * 100).toInt()}%',
                      size: AppDimens.textSize12,
                      color: AppColors.primary,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
