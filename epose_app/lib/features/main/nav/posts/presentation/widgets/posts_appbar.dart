import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../../../../../../core/configs/app_images_string.dart';
import '../../../../../../core/routes/routes.dart';
import '../controller/posts_controller.dart';

class PostsAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PostsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(left: 10, top: 10,),
          height: 50,
          child: Image.asset( AppImagesString.eEposeLogo)
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
          GetBuilder<PostsController>(
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: AppColors.primary2,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2.0);
}
