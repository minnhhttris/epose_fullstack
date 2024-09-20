import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/app_images_string.dart';

class LoadingDataPage extends StatelessWidget {
  const LoadingDataPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(AppImagesString.iLoading,width: Get.width*0.2,),
      );
  }
}