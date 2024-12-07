import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_images_string.dart';
import '../../../main/nav/clothes/presentation/widgets/clothes_card_widget.dart';
import '../controller/search_controller.dart' as local;

class SearchPage extends GetView<local.SearchController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary2,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (query) {
                    controller.searchClothes(query);
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.primary2,
                    hintText: 'Nhập để tìm kiếm...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.primary2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.primary2,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  AppImagesString.eSearch,
                  width: 24,
                  height: 24,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  controller.searchClothes(searchController.text);
                },
              ),
            ],
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: SvgPicture.asset(
        //     AppImagesString.eSearch,
        //     width: 24,
        //     height: 24,
        //     color: AppColors.primary,
        //   ),
        //     onPressed: () {
        //       controller.searchClothes(searchController
        //           .text);
        //     },
        //   ),
        // ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.listClothes.isEmpty) {
          return const Center(child: Text('Không có sản phẩm nào.'));
        }
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
              childAspectRatio: 0.6,
            ),
            itemCount: controller.listClothes.length,
            itemBuilder: (context, index) {
              return ClothesCard(
                clothes: controller.listClothes[index],
              );
            },
          ),
        );
      }),
    );
  }
}
