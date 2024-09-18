import 'package:epose_app/core/ui/widgets/appbar/appbar_widget.dart';
import 'package:epose_app/features/main/nav/posts/presentation/controller/posts_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsPage extends GetView<PostsController> {
  const PostsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('Posts Page'),
      ),
    );
  }
}
