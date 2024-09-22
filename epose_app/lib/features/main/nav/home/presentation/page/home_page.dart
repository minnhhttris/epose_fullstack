import 'package:epose_app/core/configs/app_dimens.dart';
import 'package:epose_app/core/ui/widgets/appbar/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart'; 

import '../../../../../../core/configs/app_colors.dart';
import '../controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_rounded, 
              color: AppColors.black, 
              size: AppDimens.textSize30, 
            ),
            onPressed: () {
              // Xử lý thông báo
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart, 
              color: AppColors.black,
              size: AppDimens.textSize30,
            ),
            onPressed: () {
              // Xử lý giỏ hàng
            },
          ),
          const SizedBox(width: AppDimens.columnSpacing),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần hiển thị danh sách hạng mục trang phục
            categorySection(),
            const SizedBox(height: 20),


          ],
        ),
      ),
          );
  }

  Widget categorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh mục',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Số cột trong lưới
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                var category = controller.categories[index];
                return Column(
                  children: [
                    SvgPicture.asset(
                      category['icon'] ?? " ", 
                      height: 50,
                    ),
                    const SizedBox(height: 5),
                    Text(category['name'] ?? " "),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
