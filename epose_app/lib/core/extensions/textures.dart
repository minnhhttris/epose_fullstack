

import 'package:epose_app/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class Line {
  static Container primaryLine() {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
    );
  }
}
