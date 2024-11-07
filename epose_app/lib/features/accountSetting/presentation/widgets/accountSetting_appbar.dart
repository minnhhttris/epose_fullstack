import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/ui/widgets/appbar/appbar_widget.dart';

class AccountSettingAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const AccountSettingAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        leading: InkWell(
            onTap: () => Get.back(), child: const Icon(Icons.arrow_back)),
        title: "Cài đặt tài khoản",
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
