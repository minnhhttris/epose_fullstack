import 'package:epose_app/core/ui/widgets/appbar/appbar_widget.dart';
import 'package:epose_app/features/main/nav/clothes/presentation/controller/clothes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClothesPage extends GetView<ClothesController> {
  const ClothesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('Clothes Page'),
      ),
    );
  }
}
