import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../../../../../../core/configs/app_images_string.dart';
import '../../../../../../core/routes/routes.dart';

class ProfileAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(
            left: 10,
            top: 10,
          ),
          height: 50,
          child: Image.asset(AppImagesString.eEposeLogo)
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.chat,
              color: AppColors.black,
              size: AppDimens.textSize28,
            ),
            onPressed: () {
              Get.offNamed(Routes.mesage);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: AppColors.black,
              size: AppDimens.textSize28,
            ),
            onPressed: () {
              Get.toNamed(Routes.accountSetting);
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
      )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2.0);
}
