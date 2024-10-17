import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/ui/widgets/appbar/appbar_widget.dart';
import '../controller/createStore_controller.dart';

class CreateStorePage extends GetView<CreateStoreController> {
  const CreateStorePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('CreateStore Page'),
      ),
    );
  }
}
