import 'package:epose_app/core/ui/widgets/appbar/appbar_widget.dart';
import 'package:epose_app/features/main/nav/home/presentation/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
