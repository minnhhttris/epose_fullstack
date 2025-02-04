import 'package:carousel_slider/carousel_slider.dart';
import 'package:epose_app/core/configs/app_dimens.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../clothes/presentation/widgets/clothes_card_widget.dart';
import '../controller/home_controller.dart';
import '../widgets/home_appbar_widget.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            homeSlider(),
            const SizedBox(height: 20),
            categorySection(),
            const SizedBox(height: 10),
            const Divider(
              color: AppColors.grey1,
              thickness: 1,
            ),
            topStore(),
            const Divider(
              color: AppColors.grey1,
              thickness: 1,
            ),
            const SizedBox(height: 10),
            recentPosts(),
          ],
        ),
      ),
    );
  }

  Widget homeSlider() {
    final List<String> imageList = [
      'https://thanhnien.mediacdn.vn/uploaded/nuvuong/2020_06_11/duong2_IWWM.jpg?width=500',
      'https://thanhnien.mediacdn.vn/uploaded/nuvuong/2020_06_11/huyen6_HKUU.jpg?width=500',
      'https://thanhnien.mediacdn.vn/uploaded/nuvuong/2020_06_11/1_ZKBT.jpg?width=500',
      'https://thanhnien.mediacdn.vn/uploaded/nuvuong/2020_06_11/huyen6_HKUU.jpg?width=500',
    ];

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: imageList.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Image.network(
              imageList[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: Get.height * 0.10,
              alignment: Alignment.center,
            );
          },
          options: CarouselOptions(
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 10),
            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              controller.setCurrentIndex(index);
            },
          ),
        ),
        Positioned(
          bottom: 5.0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    imageList.length,
                    (idx) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: controller.currentIndex.value == idx ? 30.0 : 5.0,
                      height: 5.0,
                      margin: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 4.0,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                        color: controller.currentIndex.value == idx
                            ? AppColors.grey1.withOpacity(0.6)
                            : AppColors.grey1.withOpacity(0.3),
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }

 Widget categorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 1,
                crossAxisSpacing: 5,
                childAspectRatio: 1,
              ),
              itemCount: controller.visibleCategories.length,
              itemBuilder: (context, index) {
                var category = controller.visibleCategories[index];

                if (category['name'] == 'Khác' &&
                    controller.showAllCategories.value) {
                  return const SizedBox.shrink();
                }

                return GestureDetector(
                  onTap: () {
                    if (category['name'] == 'Khác') {
                      controller.toggleShowAll();
                    } else {
                      Get.toNamed(
                        '/clothesByStyle',
                        arguments: category['name'],
                      );
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          color: AppColors.primary1,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          category['icon'] ?? " ",
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        category['name'] ?? " ",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }


 Widget topStore() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: 'Cửa hàng tiêu biểu',
            color: AppColors.black,
            size: AppDimens.textSize18,
            fontWeight: FontWeight.bold,
          ),
          Stack(
            children: [
              SizedBox(
                height: 100,
                child: Obx(() {
                  if (controller.listStore.isEmpty) {
                    return const Center(child: Text('Không có cửa hàng nào.'));
                  }

                  return ListView.builder(
                    controller: controller.scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.listStore.length,
                    itemBuilder: (context, index) {
                      var store = controller.listStore[index];

                      return GestureDetector(
                        onTap: () {
                          // Get.toNamed('/storeDetail', arguments: store);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    store.logo,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                store.nameStore,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              // Nút cuộn danh sách
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    controller.scrollController.animateTo(
                      controller.scrollController.offset +
                          100, // Khoảng cách cuộn
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: AppColors.white,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.grey1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget recentPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: TextWidget(
            text: "Quần áo tiêu biểu",
            size: AppDimens.textSize18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Obx(() {
          if (controller.listClothes.isEmpty) {
            return const Center(child: Text('Không có sản phẩm nào.'));
          }

          return GridView.builder(
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
              final clothes = controller.listClothes[index];

              return GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.detailsClothes, arguments: clothes.idItem);
                },
                child: ClothesCard(
                  clothes: clothes,
                ),
              );
            },
          );
        }),
      ],
    );
  }




}
