import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../../../../../../core/configs/app_images_string.dart';
import '../../../../../../core/routes/routes.dart';

class StoreAppbar extends StatelessWidget implements PreferredSizeWidget {
  const StoreAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            AppImagesString.eChart,
            width: 26,
            height: 26,
            color: AppColors.black,
          ),
          onPressed: () {
            //Get.toNamed(Routes.notify);
          },
        ),
      
        IconButton(
          icon: const Icon(
            Icons.chat,
            color: AppColors.black,
            size: AppDimens.textSize28,
          ),
          onPressed: () {
            Get.toNamed(Routes.mesage);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: AppColors.black,
            size: AppDimens.textSize28,
          ),
          onPressed: () {
            //Get.toNamed(Routes.accountSetting);
          },
        ),
        const SizedBox(width: AppDimens.columnSpacing),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(
          color: AppColors.primary2,
        ),
      ),
    ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2.0);
}
