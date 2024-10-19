import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/posts_controller.dart';
import '../widgets/posts_appbar.dart';
import '../widgets/posts_card.dart';

class PostsPage extends GetView<PostsController> {
  const PostsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PostsAppbar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(), 
          );
        }
        return controller.listPosts.isNotEmpty
       ? GetBuilder<PostsController>(
        id: "listposts",
        builder: (_) {
            return ListView.builder(
              itemCount: controller.listPosts.length,
              itemBuilder: (context, index) {
                return PostCard(post: controller.listPosts[index]);
              },
            );
        
        },
      )
      : const Center(
        child: Text("Không có bài đăng nào"),
      );
      }),
    );
  }
}
