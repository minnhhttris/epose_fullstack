import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/ui/widgets/appbar/appbar_widget.dart';
import '../controller/createClothes_controller.dart';

class CreateClothesPage extends GetView<CreateClothesController> {
  const CreateClothesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('CreateClothes Page'),
      ),
    );
  }
}
