import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/ui/widgets/appbar/appbar_widget.dart';

class AddressAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const AddressAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        leading: InkWell(
            onTap: () => Get.back(), child: const Icon(Icons.arrow_back)),
        title: "Địa chỉ",
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
