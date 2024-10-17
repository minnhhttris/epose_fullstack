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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(), 
          );
        }
        if (controller.listClothes.isEmpty) {
          return const Center(
            child: Text("Không có quần áo nào"),
          );
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleAndButtonFilter(),
              listClothes()
            ],
          ),
        );
      }),
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
         GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(3.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
              childAspectRatio: 0.6,
            ),
            itemCount: controller.listClothes.length,
            itemBuilder: (context, index) {
              final item = controller.listClothes[index];
              return ClothesCard(clothes: item);
            },
          ),
        Obx(
          () => controller.isFilterMenuOpen.value
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: Get.width * 0.6,
                    height: Get.height * 0.7,
                    color: AppColors.primary2.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            minTileHeight: 20,
                            title: const TextWidget(text: 'Giới tính'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                            ),
                            onTap: () {
                              // Handle gender filter
                            },
                          ),
                          const Divider(
                            color: AppColors.primary,
                            thickness: 0.5,
                          ),
                          ListTile(
                            minTileHeight: 20,
                            title: const Text('Theo mùa'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                            ),
                            onTap: () {
                              // Handle season filter
                            },
                          ),
                         const Divider(
                            color: AppColors.primary,
                            thickness: 0.5,
                          ),
                          ListTile(
                            minTileHeight: 20,
                            title: const Text('Màu sắc'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                            ),
                            onTap: () {
                              // Handle color filter
                            },
                          ),
                         const Divider(
                            color: AppColors.primary,
                            thickness: 0.5,
                          ),
                          ListTile(
                            minTileHeight: 20,
                            title: const Text('Giá tiền'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                            ),
                            onTap: () {
                              // Handle price filter
                            },
                          ),
                          const Divider(
                            color: AppColors.primary,
                            thickness: 0.5,
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ButtonWidget(
                                width: 100,
                                height: 40,
                                ontap: controller.resetFilters,
                                backgroundColor: AppColors.white,
                                text: 'Thiết lập lại',
                                textColor: AppColors.black,
                                borderRadius: 5,
                              ),
                              const Spacer(),
                              ButtonWidget(
                                width: 100,
                                height: 40,
                                ontap: controller.applyFilters,
                                backgroundColor: AppColors.primary,
                                text: 'Áp dụng',
                                textColor: AppColors.white,
                                borderRadius: 5,
                              ),
                            ],
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
