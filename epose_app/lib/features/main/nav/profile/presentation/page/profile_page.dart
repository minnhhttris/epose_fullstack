import 'package:epose_app/core/configs/app_dimens.dart';
import 'package:epose_app/core/configs/app_images_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/ui/widgets/avatar/avatar.dart';
import '../../../../../../core/ui/widgets/text/text_widget.dart';
import '../controller/profile_controller.dart';
import '../widgets/profile_appbar.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProfileAppbar(),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator()) 
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userInfo(),
                    const Divider(
                      color: AppColors.grey1,
                      thickness: 1,
                    ),
                    myStoreSection(),
                    const Divider(
                      color: AppColors.grey1,
                      thickness: 1,
                    ),
                    rewardSection(),
                    const Divider(
                      color: AppColors.grey1,
                      thickness: 1,
                    ),
                  ],
                ),
              );
      }),
    );
  }

  Widget userInfo() {
    return SizedBox(
      height: Get.height * 0.25,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: Get.height * 0.15,
            decoration: const BoxDecoration(
              color: AppColors.primary2,
            ),
          ),
          Positioned(
            top: Get.height * 0.10,
            child: Column(
              children: [
                Obx(() {
                  if (controller.isLoading.value) {
                    return const CircularProgressIndicator(); // Hiển thị khi avatar đang tải
                  } else {
                    return Avatar(
                        authorImg: controller.user?.avatar ?? '', radius: 70);
                  }
                }),
                const SizedBox(height: AppDimens.spacing5),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const CircularProgressIndicator(); // Hiển thị khi tên đang tải
                  } else {
                    return TextWidget(
                      text: controller.user?.userName ??
                          controller.user?.email ??
                          'User Name',
                      size: AppDimens.textSize15,
                      fontWeight: FontWeight.w400,
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget myStoreSection() {
    return GestureDetector(
      onTap: () => controller.handleStoreNavigation(),
      child: Obx(() {
        return Container(
          padding: const EdgeInsets.only(left: 30, right: 10),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget(
                    text: 'Cửa tiệm của tôi',
                    size: AppDimens.textSize15,
                    fontWeight: FontWeight.w400,
                  ),
                  TextWidget(
                    text: controller.myStore.value
                        ? (controller.isStoreActive.value
                            ? "Đến cửa hàng của bạn!"
                            : "Cửa hàng đang chờ duyệt!")
                        : "Tạo cửa hàng của bạn ngay!",
                    size: AppDimens.textSize11,
                    fontWeight: FontWeight.w300,
                    color: AppColors.grey,
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    AppImagesString.eMyStore, 
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_ios,
                      color: AppColors.grey1, size: AppDimens.textSize28),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget rewardSection() {
    return GestureDetector(
      onTap: () {
        controller.handleNavigationToCoins();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 30, right: 10),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextWidget(
                  text: 'Điểm thưởng Epose',
                  size: AppDimens.textSize15,
                  fontWeight: FontWeight.w400,
                ),
                Row(
                  children: [
                    Obx(() {
                      return TextWidget(
                        text: controller.rewardPoints.value.toString(),
                        size: AppDimens.textSize11,
                        fontWeight: FontWeight.w300,
                        color: AppColors.grey,
                      );
                    }),
                    Image.asset(
                      AppImagesString.ePoint,
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  AppImagesString.eMyGift,
                  height: 40,
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward_ios,
                    color: AppColors.grey1, size: AppDimens.textSize28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
