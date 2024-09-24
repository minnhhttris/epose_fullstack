import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../controller/clothes_controller.dart';
import '../widgets/clothes_card_widget.dart';
import '../widgets/filter_button.dart';

class ClothesPage extends GetView<ClothesController> {
  const ClothesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Tìm sản phẩm...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: AppColors.primary),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: AppColors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined,
                color: AppColors.black),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hàng chứa tiêu đề "Xu hướng" và nút lọc
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Xu hướng',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimens.textSize16,
                    color: AppColors.black,
                  ),
                ),
                FilterButton(
                  onTap: controller.toggleFilterMenu,
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Obx(
                  () => GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: controller.clothesList.length,
                    itemBuilder: (context, index) {
                      final item = controller.clothesList[index];
                      return ClothesCard(
                        imageUrl: item['imageUrl'] ?? '',
                        storeName: item['storeName'] ?? '',
                        price: item['price'] ?? '',
                        productName: item['productName'] ?? '',
                        tags: item['tags'] ?? '',
                      );
                    },
                  ),
                ),
                Obx(
                  () => controller.isFilterMenuOpen.value
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: Get.width * 0.6,
                            height: Get.height,
                            color: Colors.white.withOpacity(0.95),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: const Text('Giới tính'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    // Xử lý lọc theo giới tính
                                  },
                                ),
                                ListTile(
                                  title: const Text('Theo mùa'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    // Xử lý lọc theo mùa
                                  },
                                ),
                                ListTile(
                                  title: const Text('Màu sắc'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    // Xử lý lọc theo màu sắc
                                  },
                                ),
                                ListTile(
                                  title: const Text('Giá tiền'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    // Xử lý lọc theo giá tiền
                                  },
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: controller.resetFilters,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary
                                              .withOpacity(
                                                  0.1), // Màu nền nhẹ nhàng
                                        ),
                                        child: const Text(
                                          'Thiết lập lại',
                                          style: TextStyle(
                                              color: AppColors
                                                  .primary), // Màu chữ của nút
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: controller.applyFilters,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary, // Màu nền nút
                                        ),
                                        child: const Text('Áp dụng'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ), );
  }
}
