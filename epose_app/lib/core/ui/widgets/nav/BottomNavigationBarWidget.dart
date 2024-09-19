import 'package:flutter/material.dart';

import '../../../configs/app_colors.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onPageChanged;
  final bool allowSelect;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onPageChanged,
    this.allowSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 60, // Chiều cao của NavigationBar
      backgroundColor: AppColors.white, // Màu nền của NavigationBar
      selectedIndex: currentIndex, // Mục đang được chọn
      onDestinationSelected: allowSelect
          ? (index) {
              onPageChanged(index);
            }
          : null,
      destinations: const [

        NavigationDestination(
          icon: Icon(
            Icons.cabin_outlined,
            color: AppColors.primary,
            size: 28,
          ),
          selectedIcon: Icon(
            Icons.cabin_outlined,
            color: AppColors.primary,
            size: 28,
          ),
          label: 'Trang phục',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.picture_in_picture_alt_outlined,
            color: AppColors.primary,
            size: 28,
          ),
          selectedIcon: Icon(
            Icons.picture_in_picture_alt_outlined,
            color: AppColors.primary,
            size: 28,
          ),
          label: 'Góc Epose',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.home_filled, 
            color: AppColors.primary,
            size: 28,
          ),
          selectedIcon: Icon(
            Icons.home_filled, 
            color: AppColors.primary,
            size: 28,
          ),
          label: 'Trang chủ',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.list_alt_outlined, 
            color: AppColors.primary,
            size: 28,
          ),
          selectedIcon: Icon(
            Icons.list_alt_outlined, 
            color: AppColors.primary,
            size: 28,
          ),
          label: 'Đơn hàng',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.person, 
            color: AppColors.primary,
            size: 28,
          ),
          selectedIcon: Icon(
            Icons.person, 
            color: AppColors.primary,
            size: 28,
          ),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}
