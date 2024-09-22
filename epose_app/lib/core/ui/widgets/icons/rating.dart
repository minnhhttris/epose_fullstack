// ignore: non_constant_identifier_names
import 'package:flutter/material.dart';

import '../../../configs/app_colors.dart';

class Rating {
  // ignore: non_constant_identifier_names
  static List<Icon> RenderStar({double star=0, double sizeStar=20}) {
    if (star > 5) star = 5;
    if (star < 0) star = 0;

    bool halfStar = false;
    double ccl_1 = star % 1;

    int ccl_2 = star ~/ 1;

    if (ccl_1 > 0) halfStar = true;

    return <Icon>[
      for (var i = 1; i <= ccl_2; i++)
        Icon(
          Icons.star_rounded,
          color: AppColors.yellow,
          size: sizeStar,
        ),
      if (halfStar)
        Icon(
          Icons.star_half_rounded,
          color: AppColors.yellow,
          size: sizeStar,
        ),
      for (var i = ccl_2 + (halfStar ? 2 : 1); i <= 5; i++)
         Icon(
          Icons.star_border_rounded,
          color: AppColors.yellow,
          size: sizeStar,      
        ),
    ];
  }
}
