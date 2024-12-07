import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../../../../../../core/configs/app_images_string.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../../../../core/ui/widgets/text/text_widget.dart';
import '../controller/clothes_controller.dart';

class ClothesAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ClothesAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Get.toNamed(Routes.search);
          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.primary2, // Màu nền cho thanh tìm kiếm
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const TextWidget(
                  text: 'Tìm sản phẩm...',
                  color: Colors.grey,
                  size: AppDimens.textSize14,
                ),
                const Spacer(),
                SvgPicture.asset(
                  AppImagesString.eSearch,
                  width: 24,
                  height: 24,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
        actions: [
          // IconButton(
          //   icon: SvgPicture.asset(
          //     AppImagesString.eNotify,
          //     width: 26,
          //     height: 26,
          //     color: AppColors.black,
          //   ),
          //   onPressed: () {
          //     Get.toNamed(Routes.notify);
          //   },
          // ),
          GetBuilder<ClothesController>(
            builder: (controller) {
              final itemCount = controller.bagShopping?.items.length ?? 0;
              return badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 0),
                showBadge: itemCount > 0,
                badgeContent: Text(
                  itemCount.toString(),
                  style: const TextStyle(color: AppColors.white, fontSize: 12),
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: AppColors.primary.withOpacity(0.7),
                  elevation: 0,
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    AppImagesString.eBagShopping,
                    width: 26,
                    height: 26,
                    color: AppColors.black,
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.bagShopping);
                  },
                ),
              );
            },
          ),
          const SizedBox(width: AppDimens.columnSpacing),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2.0);
}
