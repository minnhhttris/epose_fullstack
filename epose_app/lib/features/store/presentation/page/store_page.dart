import 'package:epose_app/core/ui/widgets/avatar/avatar.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_images_string.dart';
import '../../../main/nav/clothes/presentation/widgets/clothes_card_widget.dart';
import '../controller/store_controller.dart';
import '../widgets/post_card_store.dart';
import '../widgets/store_appbar.dart';

class StorePage extends GetView<StoreController> {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController clothesScrollController = ScrollController();
    final ScrollController postsScrollController = ScrollController();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const StoreAppbar(),
        body: Column(
          children: [
            infomationStore(),
            const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: AppColors.grey,
              indicatorColor: AppColors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: "Quần áo"),
                Tab(text: "Bài đăng"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab Quần áo
                  GetBuilder<StoreController>(
                    builder: (controller) {
                      if (controller.isLoadingClothes.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return controller.listClothesOfStore.isNotEmpty
                          ? Scrollbar(
                              thumbVisibility: true,
                              controller: clothesScrollController,
                              child: GridView.builder(
                                controller: clothesScrollController,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(3.0),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 3.0,
                                  mainAxisSpacing: 3.0,
                                  childAspectRatio: 0.6,
                                ),
                                itemCount: controller.listClothesOfStore.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      controller.listClothesOfStore[index];
                                  return ClothesCard(
                                    clothes: item,
                                  );
                                },
                              ),
                            )
                          : const Center(
                              child: Text("Không có quần áo nào"),
                            );
                    },
                  ),

                  // Tab Bài đăng
                  GetBuilder<StoreController>(
                    builder: (controller) {
                      if (controller.isLoadingPosts.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return controller.listPostsOfStore.isNotEmpty
                          ? Scrollbar(
                              thumbVisibility: true,
                              controller: postsScrollController,
                              child: ListView.builder(
                                controller: postsScrollController,
                                itemCount: controller.listPostsOfStore.length,
                                itemBuilder: (context, index) {
                                  return PostCard(
                                      post: controller.listPostsOfStore[index]);
                                },
                              ),
                            )
                          : const Center(
                              child: Text("Không có bài đăng nào"),
                            );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: floatingButtonStore(context),
      ),
    );
  }

  Widget infomationStore() {
    return Container(
            height:
                Get.height * 0.2, 
            color: AppColors.primary2,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                GetBuilder<StoreController>(
                  builder: (controller) {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Avatar(
                      radius: 60,
                      authorImg: controller.store?.logo ?? "",
                    );
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GetBuilder<StoreController>(
                    builder: (controller) {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Tên cửa hàng
                          TextWidget(
                            text: controller.store?.nameStore ?? "",
                            size: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 8),
                          // Địa chỉ cửa hàng
                          TextWidget(
                            text: controller.store?.address ??
                                "Không có địa chỉ",
                            size: 14,
                            color: AppColors.grey,
                            maxLines: 3, 
                          ),
                          const SizedBox(height: 8),
                          // Thanh đánh giá sao
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: controller.store?.rate ?? 0.0,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                              const SizedBox(width: 8),
                              // Hiển thị điểm đánh giá
                              TextWidget(
                                text: controller.store?.rate
                                        .toStringAsFixed(1) ??
                                    "0.0",
                                size: 14,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  FloatingActionButton floatingButtonStore(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  leading: SvgPicture.asset(
                    AppImagesString.eClothes,
                    height: 28,
                    color: AppColors.black,
                  ),
                  title: const TextWidget(
                    text: 'Tạo quần áo cho thuê',
                    size: 16,
                  ),
                  onTap: () {
                    controller.handleCreateClothesNavigation();
                  },
                ),
                const Divider(),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  leading: SvgPicture.asset(
                    AppImagesString.ePosts,
                    height: 28,
                    color: AppColors.black,
                  ),
                  title: const TextWidget(
                    text: 'Tạo bài viết',
                    size: 16,
                  ),
                  onTap: () {
                    controller.handleCreatePostsNavigation();
                  },
                ),
              ],
            );
          },
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      clipBehavior: Clip.antiAlias,
      backgroundColor: AppColors.primary,
      child: const Icon(
        Icons.add,
        color: AppColors.white,
      ),
    );
  }
}
