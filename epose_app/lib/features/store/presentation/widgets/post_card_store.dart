import 'package:epose_app/core/configs/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/routes/routes.dart';
import '../../../../../../core/services/model/posts_model.dart';
import '../../../../../../core/ui/widgets/text/text_widget.dart';
import '../controller/store_controller.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final postController = Get.find<StoreController>();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  late bool isFavorited;
  late int favoriteCount;
  bool isExpanded = false; 

  @override
  void initState() {
    super.initState();
    isFavorited = widget.post.isFavoritedByUser;
    favoriteCount = widget.post.favorites.length;
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
              backgroundImage: NetworkImage(widget.post.store!.logo),
            ),
            title: TextWidget(
              text: widget.post.store!.nameStore,
              size: 16,
              fontWeight: FontWeight.bold,
            ),
            subtitle: Text(
              formatter.format(widget.post.createdAt),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildCaption(),
                const SizedBox(height: 10),
                if (widget.post.picture.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.detailsPosts,
                          arguments: widget.post.idPosts);
                    },
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(widget.post.picture.first,
                          fit: BoxFit.cover),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => toggleFavorite(),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 20,
                              color:
                                  isFavorited ? AppColors.red : AppColors.grey3,
                            ),
                            const SizedBox(width: 8),
                            TextWidget(
                              text: "$favoriteCount",
                              color: AppColors.grey,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.detailsPosts,
                              arguments: widget.post.idPosts);
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
                              text: "${widget.post.comments.length}",
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

  void toggleFavorite() async {
    if (isFavorited) {
      await postController.unfavoritePost(widget.post.idPosts);
      setState(() {
        isFavorited = false;
        favoriteCount--;
      });
    } else {
      await postController.favoritePost(widget.post.idPosts);
      setState(() {
        isFavorited = true;
        favoriteCount++;
      });
    }
  }

  Widget buildCaption() {
    final String fullCaption = widget.post.caption;
    if (isExpanded || fullCaption.length <= 140) {
      return Text(
        fullCaption,
        style: const TextStyle(fontSize: 14, height: 1.5),
      );
    } else {
      return Text.rich(
        TextSpan(
          text: '${fullCaption.substring(0, 140)}...',
          children: [
            TextSpan(
              text: 'Xem thêm',
              style: const TextStyle(color: AppColors.primary),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isExpanded = true;
                  });
                },
            ),
          ],
        ),
        style: const TextStyle(fontSize: 14, height: 1.5),
      );
    }
  }
}
