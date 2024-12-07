import 'package:flutter/material.dart';

import '../../../../../../core/configs/app_colors.dart';

class BillOfStoreAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BillOfStoreAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn thuê của cửa hàng'),
        centerTitle: true,
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
