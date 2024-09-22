import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_dimens.dart';
import '../../../../core/configs/app_images_string.dart';
import '../../../../core/data/pref/prefs';
import '../../../../core/routes/routes.dart';
import '../controller/onBoarding_controller.dart';

class OnBoardingPage extends GetView<OnBoardingController> {
  OnBoardingPage({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: PageView(
          controller: _pageController,
          children: [
            _buildPage(
              title:
                  ' Bạn có phải là một người yêu thời trang và thích chụp ảnh không?',
              imagePath: AppImagesString.eOnBoarding1,
              buttonText: 'Kế tiếp',
              buttonAction: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
              skipText: 'Bỏ qua',
            ),
            _buildPage(
              title:
                  ' Bạn có biết lĩnh vực thời trang hiện đang tạo ra một lượng rác thải rất lớn, mỗi năm khoảng 92 triệu tấn rác thải, chiếm 10% tổng lượng khí thải carbon toàn cầu',
              imagePath: AppImagesString.eOnBoarding2,
              buttonText: 'Kế tiếp',
              buttonAction: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
              skipText: 'Bỏ qua',
            ),
            _buildPage(
              title:
                  ' Vì vậy mà “thời trang bền vững” ra đời. Hãy để thời trang không chỉ đẹp mà còn bền vững. Thuê trang phục và làm đẹp môi trường cùng chúng tôi.',
              imagePath: AppImagesString.eOnBoarding3,
              buttonText: 'Bắt đầu nào',
              buttonAction: () async {
                // Lưu trạng thái đã xem Onboarding và điều hướng đến trang chính
                await Prefs.preferences.setBool('isFirstLaunch', false);
                Get.offNamed(Routes.main);
              },
              skipText: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String imagePath,
    required String buttonText,
    required Function() buttonAction,
    required String skipText,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Phần đầu trang
        Padding(
          padding: const EdgeInsets.only(
              top: 40), // Thêm khoảng cách phía trên nếu cần
          child: TextWidget(
            textAlign: TextAlign.center,
            text: title,
            color: AppColors.primary,
            size: AppDimens.textSize16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            imagePath,
            height: Get.width, 
            width: Get.width, 
            fit: BoxFit.contain, 
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 40), // Khoảng cách dưới cùng
          child: Column(
            children: [
              ButtonWidget(
                text: buttonText,
                ontap: buttonAction,
                height: 52,
                borderRadius: 10,
              ),
              if (skipText.isNotEmpty)
                ButtonWidget(
                  text: skipText,
                  textColor: AppColors.primary,
                  backgroundColor: Colors.transparent,
                  ontap: () async {
                    // Bỏ qua Onboarding và điều hướng đến trang chính
                    await Prefs.preferences.setBool('isFirstLaunch', false);
                    Get.offNamed(Routes.splash);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
