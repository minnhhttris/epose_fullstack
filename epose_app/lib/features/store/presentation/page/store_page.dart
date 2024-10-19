import 'package:epose_app/core/ui/widgets/avatar/avatar.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_images_string.dart';
import '../../../../core/routes/routes.dart';
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

    return controller.isLoading.value
        ? DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: const StoreAppbar(),
              body: Column(
                children: [
                  Container(
                    height: Get.height * 0.16,
                    color: AppColors.primary2,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return Avatar(
                            radius: 50,
                            authorImg: controller.store != null
                                ? controller.store!.logo
                                : "",
                          );
                        }),
                        const SizedBox(width: 16),
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return TextWidget(
                            text: controller.store != null
                                ? controller.store!.nameStore
                                : "",
                            size: 18,
                            fontWeight: FontWeight.bold,
                          );
                        }),
                      ],
                    ),
                  ),
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
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return controller.listClothesOfStore.isNotEmpty
                              ? GetBuilder<StoreController>(
                                  id: "listClothesOfStore",
                                  builder: (_) {
                                    return Scrollbar(
                                      thumbVisibility: true,
                                      controller: clothesScrollController,
                                      child: GridView.builder(
                                        controller: clothesScrollController,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.all(3.0),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 3.0,
                                          mainAxisSpacing: 3.0,
                                          childAspectRatio: 0.6,
                                        ),
                                        itemCount: controller
                                            .listClothesOfStore.length,
                                        itemBuilder: (context, index) {
                                          final item = controller
                                              .listClothesOfStore[index];
                                          return ClothesCard(clothes: item);
                                        },
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text("Không có quần áo nào"),
                                );
                        }),

                        // Tab Bài đăng
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return controller.listPostsOfStore.isNotEmpty
                              ? GetBuilder<StoreController>(
                                  id: "listPostsOfStore",
                                  builder: (_) {
                                    return Scrollbar(
                                      thumbVisibility: true,
                                      controller: postsScrollController,
                                      child: ListView.builder(
                                        controller: postsScrollController,
                                        itemCount:
                                            controller.listPostsOfStore.length,
                                        itemBuilder: (context, index) {
                                          return PostCard(
                                              post: controller
                                                  .listPostsOfStore[index]);
                                        },
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text("Không có bài đăng nào"),
                                );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              floatingActionButton: floatingButtonStore(context),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
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
                    Get.toNamed(Routes.createClothes);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Divider(),
                ),
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
                    Get.toNamed(Routes.createPosts);
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
      hoverColor: AppColors.primary.withOpacity(0.5),
      backgroundColor: AppColors.primary,
      child: const Icon(
        Icons.add,
        color: AppColors.white,
      ),
    );
  }
}
