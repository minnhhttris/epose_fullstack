import 'package:epose_app/core/ui/widgets/appbar/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../../../../../../core/routes/routes.dart';

class ProfileAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
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
              Icons.shopping_cart,
              color: AppColors.black,
              size: AppDimens.textSize28,
            ),
            onPressed: () {
              Get.toNamed(Routes.bagShopping);
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
      )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2.0);
}
