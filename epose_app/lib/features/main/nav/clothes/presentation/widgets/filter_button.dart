import 'package:flutter/material.dart';

import '../../../../../../core/configs/app_colors.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback onTap;

  const FilterButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(
        Icons.filter_list,
        color: AppColors.black,
      ),
    );
  }
}
