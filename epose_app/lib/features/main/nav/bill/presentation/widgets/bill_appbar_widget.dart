import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../../../../../../core/configs/app_images_string.dart';
import '../../../../../../core/routes/routes.dart';

class BillAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BillAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppImagesString.eNotify,
              width: 26,
              height: 26,
              color: AppColors.black,
            ),
            onPressed: () {
              Get.toNamed(Routes.notify);
            },
          ),
          IconButton(
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
          const SizedBox(width: AppDimens.columnSpacing),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2.0);
}
