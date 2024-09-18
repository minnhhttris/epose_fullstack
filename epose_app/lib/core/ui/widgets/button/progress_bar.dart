import 'package:epose_app/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20.0,
      width: 20.0,
      child: CircularProgressIndicator(
        color: AppColors.white,
      ),
    );
  }
}
