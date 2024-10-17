import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/ui/widgets/appbar/appbar_widget.dart';
import '../controller/createPosts_controller.dart';

class CreatePostsPage extends GetView<CreatePostsController> {
  const CreatePostsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('CreatePosts Page'),
      ),
    );
  }
}
