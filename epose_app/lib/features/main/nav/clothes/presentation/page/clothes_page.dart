import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../controller/clothes_controller.dart';
import '../widgets/clothes_appbar_widget.dart';
import '../widgets/clothes_card_widget.dart';
import '../widgets/filter_button.dart';

class ClothesPage extends GetView<ClothesController> {
  const ClothesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ClothesAppbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleAndButtonFilter(),
            listClothes(),
          ],
        ),
      ),
    );
  }

  Padding titleAndButtonFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Xu hướng',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimens.textSize18,
              color: AppColors.black,
            ),
          ),
          FilterButton(
            onTap: controller.toggleFilterMenu,
          ),
        ],
      ),
    );
  }

   Widget listClothes() {
    return Stack(
      children: [
        Obx(
          () => GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn riêng của GridView
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    width: Get.width * 0.7,
                    height: Get.height * 0.5,
                    color: AppColors.primary2.withOpacity(0.90),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: const TextWidget(text: 'Giới tính'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                            ),
                            onTap: () {
                              // Xử lý lọc theo giới tính
                            },
                          ),
                          const Divider(
                            color: AppColors.primary,
                            thickness: 1,
                          ),
                          ListTile(
                            title: const Text('Theo mùa'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                            ),
                            onTap: () {
                              // Xử lý lọc theo mùa
                            },
                          ),
                          const Divider(
                            color: AppColors.primary,
                            thickness: 1,
                          ),
                          ListTile(
                            title: const Text('Màu sắc'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                            ),
                            onTap: () {
                              // Xử lý lọc theo màu sắc
                            },
                          ),
                          const Divider(
                            color: AppColors.primary,
                            thickness: 1,
                          ),
                          ListTile(
                            title: const Text('Giá tiền'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                            ),
                            onTap: () {
                              // Xử lý lọc theo giá tiền
                            },
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ButtonWidget(
                                  width: 120,
                                  height: 40,
                                  ontap: controller.resetFilters,
                                  backgroundColor: AppColors.white,
                                  text: 'Thiết lập lại',
                                  textColor: AppColors.black,
                                  borderRadius: 5,
                                ),
                                const Spacer(),
                                ButtonWidget(
                                  width: 120,
                                  height: 40,
                                  ontap: controller.applyFilters,
                                  backgroundColor: AppColors.primary,
                                  text: 'Áp dụng',
                                  textColor: AppColors.white,
                                  borderRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
