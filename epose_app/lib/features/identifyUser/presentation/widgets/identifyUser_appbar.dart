import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/ui/widgets/appbar/appbar_widget.dart';

class IdentifyUserAppbar extends StatelessWidget implements PreferredSizeWidget {
  const IdentifyUserAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        leading: InkWell(
            onTap: () => Get.back(result: true), child: const Icon(Icons.arrow_back)),
        title: "Định danh tài khoản",
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
