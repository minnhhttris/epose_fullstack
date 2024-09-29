import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../../../../../../core/configs/app_images_string.dart';
import '../controller/clothes_controller.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback onTap;

  const FilterButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () {
          bool isMenuOpen =
              Get.find<ClothesController>().isFilterMenuOpen.value;
          return SvgPicture.asset(
            isMenuOpen
                ? AppImagesString.eFilterOpen
                : AppImagesString.eFilter,
            color: AppColors.black,
            width: AppDimens.textSize24, 
            height: AppDimens.textSize26, 
          );
        },
      ),
    );
  }
}
