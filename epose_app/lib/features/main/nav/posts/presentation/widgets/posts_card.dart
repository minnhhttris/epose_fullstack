import 'package:epose_app/core/configs/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/routes/routes.dart';
import '../../../../../../core/services/model/posts_model.dart';
import '../../../../../../core/ui/widgets/text/text_widget.dart';
import '../controller/posts_controller.dart';


class PostCard extends StatelessWidget {
  final PostModel post;
  final postController = Get.find<
      PostsController>(); 
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  PostCard({Key? key, required this.post}) : super(key: key) {
    postController
        .initPost(post); 
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.store!.logo),
            ),
            title: TextWidget(
              text: post.store!.nameStore,
              size: 16,
              fontWeight: FontWeight.bold,
            ),
            subtitle: Text(
              formatter.format(post.createdAt),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Obx(() => buildCaption()),
                const SizedBox(height: 10),
                if (post.picture.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.detailsPosts, arguments: post.idPosts);
                    },
                    child: AspectRatio(
                      aspectRatio: 1,
                      child:
                          Image.network(post.picture.first, fit: BoxFit.cover),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Obx(() => GestureDetector(
                            onTap: () => postController.toggleFavorite(
                                post), // Đã đổi từ storeController thành postController
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 20,
                                  color: postController.isFavorited
                                          .value // Đã đổi từ storeController thành postController
                                      ? AppColors.red
                                      : AppColors.grey3,
                                ),
                                const SizedBox(width: 8),
                                TextWidget(
                                  text:
                                      "${postController.favoriteCount}", // Đã đổi từ storeController thành postController
                                  color: AppColors.grey,
                                  size: 14,
                                ),
                              ],
                            ),
                          )),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.detailsPosts,
                              arguments: post.idPosts);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.comment_rounded,
                              size: 20,
                              color: AppColors.grey3,
                            ),
                            const SizedBox(width: 8),
                            TextWidget(
                              text: "${post.comments.length}",
                              color: AppColors.grey,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCaption() {
    final String fullCaption = post.caption;

    if (postController.isExpanded.value || fullCaption.length <= 100) {
      // Đã đổi từ storeController thành postController
      return Text.rich(
        TextSpan(
          text: fullCaption,
          children: [
            if (fullCaption.length > 100)
              TextSpan(
                text: ' ',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    postController.isExpanded.value =
                        false; // Đã đổi từ storeController thành postController
                  },
              ),
          ],
        ),
        style: const TextStyle(fontSize: 14, height: 1.5),
      );
    } else {
      return Text.rich(
        TextSpan(
          text: '${fullCaption.substring(0, 140)}...',
          children: [
            TextSpan(
              text: ' Xem thêm',
              style: const TextStyle(color: AppColors.primary),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  postController.isExpanded.value =
                      true; // Đã đổi từ storeController thành postController
                },
            ),
          ],
        ),
        style: const TextStyle(fontSize: 14, height: 1.5),
      );
    }
  }
}
