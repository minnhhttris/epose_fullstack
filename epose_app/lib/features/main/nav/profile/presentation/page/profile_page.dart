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
      body: SingleChildScrollView(
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
      ),
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
                GestureDetector(
                  child: GetBuilder<ProfileController>(
                    id: "updateAvatar",
                    builder: (_) {
                      return Avatar(
                          authorImg: controller.user?.email ?? '', radius: 60);
                    },
                  ),
                ),
                const SizedBox(height: AppDimens.spacing5),
                TextWidget(
                  text: controller.user?.email ?? 'User name',
                  size: AppDimens.textSize14,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget myStoreSection() {
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
                size: AppDimens.textSize14,
                fontWeight: FontWeight.w400,
              ),
              Obx(() {
                return TextWidget(
                  text: controller.myStore.value,
                  size: AppDimens.textSize10,
                  fontWeight: FontWeight.w200,
                  color: AppColors.gray,
                );
              }),
            ],
          ),
          Row(
            children: [
              Image.asset(
                AppImagesString.eMyStore, // Đường dẫn đến hình ảnh PNG
                height: 40,
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios,
                    color: AppColors.grey1, size: AppDimens.textSize28),
                onPressed: () {
                  // Xử lý chuyển trang
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget rewardSection() {
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
                text: 'Điểm thưởng Epose',
                size: AppDimens.textSize14,
                fontWeight: FontWeight.w400,
              ),
              Row(
                children: [
                  Obx(() {
                    return TextWidget(
                      text: controller.rewardPoints.value.toString(),
                      size: AppDimens.textSize10,
                      fontWeight: FontWeight.w200,
                      color: AppColors.gray,
                    );
                  }),
                  Image.asset(
                    AppImagesString.ePoint,
                    height: 40,
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
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios,
                    color: AppColors.grey1, size: AppDimens.textSize28),
                onPressed: () {
                  // Xử lý chuyển trang
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
