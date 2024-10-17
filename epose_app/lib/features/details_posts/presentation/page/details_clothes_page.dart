import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/details_clothes_controller.dart';


class DetailsClothesPage extends GetView<DetailsClothesController> {
  const DetailsClothesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return controller.clothes == null
            ? const Center(child: Text("No data available"))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                  ],
                ),
              );
      }),
    );
  }
}
