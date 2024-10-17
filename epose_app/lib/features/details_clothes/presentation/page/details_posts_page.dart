import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/ui/widgets/avatar/avatar.dart';
import '../controller/details_posts_controller.dart';
import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_images_string.dart';
import '../../../../../../core/ui/widgets/button/button_widget.dart';
import '../../../../../../core/ui/widgets/text/text_widget.dart';

class DetailsPostsPage extends GetView<DetailsPostsController> {
  const DetailsPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: detailsPostsAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Hiển thị loading toàn trang
        }
        return controller.post == null
            ? const Center(child: Text("No data available"))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: controller.post!.caption,
                            size: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          const SizedBox(height: 10),
                          if (controller.post!.picture.isNotEmpty)
                            buildImageCarousel(controller),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => GestureDetector(
                              onTap: controller.isLoading.value
                                  ? null
                                  : () {
                                      controller.toggleFavorite();
                                    },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size: 22,
                                    color: controller.isFavorited.value
                                        ? AppColors.red
                                        : AppColors.grey3,
                                  ),
                                  const SizedBox(width: 8),
                                  TextWidget(
                                    text: "${controller.favoriteCount}",
                                    color: AppColors.grey,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.comment_rounded,
                                  color: Colors.grey, size: 22),
                              const SizedBox(width: 8),
                              TextWidget(
                                text: "${controller.post!.comments.length}",
                                size: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: AppColors.grey1,
                    ),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _buildCommentSection(controller);
                    }),
                  ],
                ),
              );
      }),
    );
  }

  AppBar detailsPostsAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Obx(() {
        return controller.isLoading.value
            ? const CircularProgressIndicator()
            : controller.post == null
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(controller.post!.store!.logo),
                    ),
                  );
      }),
      title: Obx(() {
        return controller.isLoading.value
            ? const Text('Loading...')
            : controller.post == null
                ? const Text('No post found')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: controller.post!.store!.nameStore,
                        size: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(controller.post!.createdAt),
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.grey),
                      ),
                    ],
                  );
      }),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ButtonWidget(
            ontap: controller.isLoading.value ? () {} : () {},
            text: "Theo dõi",
            height: 30,
            width: 100,
            fontWeight: FontWeight.w300,
            textColor: AppColors.black,
            backgroundColor: Colors.white,
            isBorder: true,
            borderColor: AppColors.grey1,
          ),
        ),
      ],
    );
  }

  Widget buildImageCarousel(DetailsPostsController controller) {
    PageController pageController =
        PageController(initialPage: controller.currentImageIndex.value);

    return Column(
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: PageView.builder(
                controller: pageController,
                itemCount: controller.post!.picture.length,
                onPageChanged: (index) {
                  controller.currentImageIndex.value = index;
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    controller.post!.picture[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Obx(() {
              return controller.currentImageIndex.value > 0
                  ? Positioned(
                      left: 10,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  if (controller.currentImageIndex.value > 0) {
                                    controller.currentImageIndex.value--;
                                    pageController.jumpToPage(
                                        controller.currentImageIndex.value);
                                  }
                                },
                        ),
                      ),
                    )
                  : Container();
            }),
            Obx(() {
              return controller.currentImageIndex.value <
                      controller.post!.picture.length - 1
                  ? Positioned(
                      right: 10,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: controller.isLoading.value
                              ? null // Vô hiệu hóa chuyển đổi khi đang loading
                              : () {
                                  if (controller.currentImageIndex.value <
                                      controller.post!.picture.length - 1) {
                                    controller.currentImageIndex.value++;
                                    pageController.jumpToPage(
                                        controller.currentImageIndex.value);
                                  }
                                },
                        ),
                      ),
                    )
                  : Container();
            }),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.post!.picture.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: controller.isLoading.value
                    ? null // Vô hiệu hóa tương tác khi đang loading
                    : () {
                        controller.currentImageIndex.value = index;
                        pageController.jumpToPage(index);
                      },
                child: Obx(() => Container(
                      foregroundDecoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                            controller.currentImageIndex.value == index
                                ? 0
                                : 0.4),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.network(
                        controller.post!.picture[index],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommentSection(DetailsPostsController controller) {
    ScrollController scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          controller.post!.comments.isEmpty
              ? SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppImagesString.eNoComment,
                          width: 100,
                          height: 100,
                        ),
                        const Text('Chưa có bình luận nào'),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 300,
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.post!.comments.length,
                      itemBuilder: (context, index) {
                        final comment = controller.post!.comments[index];

                        return GestureDetector(
                          onLongPress: () {
                            if (comment.user!.idUser ==
                                controller.user!.idUser) {
                              controller.showDeleteConfirmationDialog(
                                  comment.idComment, comment.user!.idUser);
                            } else {
                              controller.cannotDeleteComment();
                            }
                          },
                          child: ListTile(
                            leading: controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Avatar(
                                    authorImg: comment.user != null
                                        ? comment.user!.avatar
                                        : "",
                                    radius: 40,
                                  ),
                            title: comment.user != null
                                ? Text(
                                    comment.user!.userName ??
                                        comment.user!.email,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                : const Text('Ẩn danh'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(comment.createdAt),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 5),
                                Text(comment.comment),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
          _buildCommentInput(controller),
        ],
      ),
    );
  }

  // Hàm nhập bình luận
  Widget _buildCommentInput(DetailsPostsController controller) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            maxLines: null,
            minLines: 1,
            controller: controller.commentController,
            decoration: const InputDecoration(
              hintText: 'Viết bình luận...',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) async {
              if (value.trim().isEmpty) {
                await controller.addComment(controller.post!.idPosts, value);
                controller.commentController.clear();
              }
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            controller.addComment(
                controller.post!.idPosts, controller.commentController.text);
            controller.commentController.clear();
          },
        ),
      ],
    );
  }
}
